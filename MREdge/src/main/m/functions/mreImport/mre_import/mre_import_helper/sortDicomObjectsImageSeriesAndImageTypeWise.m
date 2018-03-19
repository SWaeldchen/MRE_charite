function [ imageSeries ] = sortDicomObjectsImageSeriesAndImageTypeWise( raw_dicom_objects )
%INDEXIMAGESERIES Summary of this function goes here
%   Detailed explanation goes here



map=javaObject('java.util.HashMap');
for index=1:length(raw_dicom_objects)
%     seriesUID=raw_dicom_objects(index).info.SeriesInstanceUID;
    seriesUID=[raw_dicom_objects(index).info.SeriesInstanceUID raw_dicom_objects(index).info.ImageType];
    if map.containsKey(seriesUID)
        indices=map.get(seriesUID);
        indices=[indices; index];
        map.put(seriesUID,indices);
    else
        map.put(seriesUID,index);
    end
end

selectors=map.values.toArray;
nSeries=length(selectors);
imageSeries=cell(1,nSeries);
for index=1:nSeries
    imageSeries{index}=raw_dicom_objects(selectors(index));
end

