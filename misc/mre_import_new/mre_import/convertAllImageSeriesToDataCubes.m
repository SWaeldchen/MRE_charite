function [ dataCubes] = convertAllImageSeriesToDataCubes(imageSeries)
%CONVERTDICOMIMAGESERIESTOMATLAB Summary of this function goes here
%   Detailed explanation goes here


cellTypeNames={'FileName','AcquisitionTime','ContentTime','ImageComments',...
    'CSAImageHeaderInfo','SOPInstanceUID'};
singleValueTypeNames={'AcquisitionNumber','InstanceNumber','SliceLocation'};
vectorTypeNames={'ImagePositionPatient','ImageOrientationPatient'};

if ~iscell(imageSeries)
    imageSeries={imageSeries};
end
    


% dataCubes=cell(size(imageSeries));
dataCubes=struct('info', {}, 'cube', {}, 'fullPath', {});
for iter=1:numel(imageSeries)
    dataCubes(iter)=createDataCubeFromSeriesInstances(imageSeries{iter});
end

    function [ dataCube ] = createDataCubeFromSeriesInstances( instances )
            
        
        
        dataCube=struct();
        dataCube.info=instances(1).info;
        
        dataCube.cube=concatImages(instances);
        dataCube.fullPath=concatFullPaths(instances);
        
        dataCube=concatAllCellTypes(dataCube,instances,cellTypeNames);
        dataCube=concatAllSingleValueTypes(dataCube,instances,singleValueTypeNames);
        dataCube=concatAllVectorTypes(dataCube,instances,vectorTypeNames);
        
        
%         dataCube=autoExtractMetaInformationFromDicomHeaders(dataCube);
    end

    function dataCube=concatAllSingleValueTypes(dataCube,instances,typeNames)
        nImages=numel(instances);
        for index=1:length(typeNames)
            typeName=typeNames{index};
            dataCube.info.(typeName)=zeros(1,nImages);
            for imIndex=1:nImages
                if isfield(instances(imIndex).info,typeName)
                    values=dataCube.info.(typeName);
                    values(imIndex)=instances(imIndex).info.(typeName);
                    dataCube.info.(typeName)=values;
                end
            end
        end
    end

    function dataCube=concatAllCellTypes(dataCube,instances,typeNames)
        nImages=numel(instances);
        for index=1:length(typeNames)
            typeName=typeNames{index};
            dataCube.info.(typeName)=cell(1,nImages);
            for imIndex=1:nImages
                if isfield(instances(imIndex).info,typeName)
                    values=dataCube.info.(typeName);
                    values{imIndex}=instances(imIndex).info.(typeName);
                    dataCube.info.(typeName)=values;
                end
            end
        end
    end

    function dataCube=concatAllVectorTypes(dataCube,instances,typeNames)
        nImages=numel(instances);
        for index=1:length(typeNames)
            typeName=typeNames{index};
            dataCube.info.(typeName)=zeros(numel(instances(1).info.(typeName)),nImages);
            for imIndex=1:nImages
                if isfield(instances(imIndex).info,typeName)
                    values=dataCube.info.(typeName);
                    values(:,imIndex)=instances(imIndex).info.(typeName);
                    dataCube.info.(typeName)=values;
                end
            end
        end
    end

    function cube=concatImages(instances)
        nImages=numel(instances);
        cube=zeros([size(instances(1).img) nImages]);
        for imIndex=1:nImages
            cube(:,:,imIndex)=instances(imIndex).img;
        end
    end


    function fullPaths=concatFullPaths(instances)
        nImages=numel(instances);
        fullPaths=cell(1,nImages);
        for imIndex=1:nImages
            fullPaths{imIndex}=instances(imIndex).fullPath;
        end
    end


end

