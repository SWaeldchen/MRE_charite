function [ tableContent ] = getCubeInfoCell( currCube )
%GETCUBEINFOCELL Summary of this function goes here
%   Detailed explanation goes here

cubeSizeFormatString='(%3.3s;%3.3s;%3.3s;%3.3s;%3.3s;%3.3s;%3.3s)';
patientName=currCube.patientName;
seriesDescription=createSeriesDescriptionString(currCube.SeriesDescription);
studyDate=currCube.StudyDate;
acquisitionTimes=floor([currCube.ImageInfo(:).AcquisitionTime]);
timeString=[num2str(min(acquisitionTimes)) '-' num2str(max(acquisitionTimes)) ];
%     seriesTime=createSeriesDescriptionString({num2str(round(str2double([currCube.SeriesTime{:}])))});
cubeSizeString=createCubeSizeString(cubeSizeFormatString,currCube.cube);




tableContent={...
    mat2str(sort([currCube.SeriesNumber_magn currCube.SeriesNumber_phase])),...
    seriesDescription,...
    cubeSizeString,...
    timeString,...
    studyDate,...
    patientName...
    };


    function descriptionString=createSeriesDescriptionString(seriesDescriptions)
        uniqueDescriptions=unique(seriesDescriptions);
        descriptionString=[];
        for ind=1:(length(uniqueDescriptions)-1)
            descriptionString=[descriptionString uniqueDescriptions{ind} '; '];
        end
        descriptionString=[descriptionString uniqueDescriptions{end}];
    end


    function cubeSizeString=createCubeSizeString(formatString,cube)
        cubeSizeString=sprintf(formatString,...
            num2str(size(cube,1)),num2str(size(cube,2)),num2str(size(cube,3)),...
            num2str(size(cube,4)),num2str(size(cube,5)),num2str(size(cube,6)),...
            num2str(size(cube,7)));
    end

end

