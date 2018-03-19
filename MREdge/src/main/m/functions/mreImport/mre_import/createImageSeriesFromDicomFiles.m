function [ imageSeries ] = createImageSeriesFromDicomFiles(path,wildcard)
%CREATEIMAGESERIESFROMDICOMFILES Summary of this function goes here
%   Detailed explanation goes here

%import mre_import.mre_import_helper.*;

defaultPath=pwd;
defaultWildCard='.IMA|.ima|.dcm|.DCM';

if nargin<2
    wildcard=defaultWildCard;
    if nargin < 1
        path=defaultPath;
    end
end

[ raw_dicom_objects ] = createRawDicomObjects( path,wildcard );
[ uniqueDicomObjects ] = removeDuplicates(raw_dicom_objects);
if length(raw_dicom_objects)>length(uniqueDicomObjects)
    nDeleted=length(raw_dicom_objects)-length(uniqueDicomObjects);
    warning(['Duplicate dicom files (' num2str(nDeleted) ') found according to SOPInstance UID.. removed']);
    raw_dicom_objects=uniqueDicomObjects;
end
clear uniqueDicomObjects;

[ imageSeries ] = sortDicomObjectsImageSeriesAndImageTypeWise( raw_dicom_objects );
imageSeries=sortImageSeriesAfterSeriesNumber(imageSeries);
for iter=1:length(imageSeries)
    imageSeries{iter}=sortInstancesOfASeriesViaInstanceNumber(imageSeries{iter});
end



    function sortedSeries=sortImageSeriesAfterSeriesNumber(series)
        seriesNumbers=cell(1,length(series));
        for index=1:length(series)
            currSeries=series{index};
            dicomHeader=currSeries(1).info;
            
            seriesNumbers{index}=[dicomHeader.SeriesDate dicomHeader.SeriesTime];
        end
        [sorted,I]=sort(seriesNumbers);
        sortedSeries=series(I);
    end

    function sortedInstances=sortInstancesOfASeriesViaInstanceNumber(instances)
        instanceNumbers=zeros(length(instances),1);
        for index=1:length(instances)
            dicomHeader=instances(index).info;
            instanceNumbers(index)=getDicomHeaderInfo(dicomHeader,'InstanceNumber');
        end
        [sorted,I]=sort(instanceNumbers);
        uniqueInstanceNumbers=unique(sorted);
        if numel(uniqueInstanceNumbers)==numel(sorted)
            sortedInstances=instances(I);
        else
            coilIndex=zeros(length(instances),1);
            echoIndex=zeros(length(instances),1);
            for index=1:length(instances)
                dicomHeader=instances(index).info;
                iceDim=getDicomHeaderInfo(dicomHeader,'AllIceDims');
                coilIndex(index)=iceDim.channel;
                echoIndex(index)=iceDim.echo;
            end
            M=[instanceNumbers echoIndex coilIndex];
            [sorted,I]=sortrows(M);
            sortedInstances=instances(I);
        end
    end

    function uniqueDicomObjects=removeDuplicates(dicomObjects)
        nObjects=length(dicomObjects);
        uids=cell(1,nObjects);
        for index=1:nObjects
            uids{index}=dicomObjects(index).info.SOPInstanceUID;
        end
        [uniqueUIDs uniqueIndices]=unique(uids);
        uniqueDicomObjects=dicomObjects(uniqueIndices);
    end


end

