function [ output_args ] = displayComplexMreCubes( complexCubes )
%DISPLAYCOMPLEXMRECUBES Summary of this function goes here
%   Detailed explanation goes here


formatString='%-5.5s %-30.30s %-30.30s %-15.15s %-10.10s %-30.30s';
s=sprintf(formatString,'(#): ',...
    'SERIES DESCRIPTION','CUBE SIZE','ACQ. TIME','DATE','PATIENT NAME');


cubeSizeFormatString='(%3.3s;%3.3s;%3.3s;%3.3s;%3.3s;%3.3s;%3.3s)';
s2=sprintf(formatString,'',...
    '',sprintf(cubeSizeFormatString,'y','x','z','ts','dir','fre','sess'),'');


display([s '']);
display([s2 '']);
lineString=repmat('-',1,length(s));

display([lineString '']);
for index=1:length(complexCubes)
    currCube=complexCubes(index);
    
    patientName=currCube.patientName;
    seriesDescription=createSeriesDescriptionString(currCube.SeriesDescription);
    studyDate=currCube.StudyDate;
    acquisitionTimes=floor([currCube.ImageInfo(:).AcquisitionTime]);
    timeString=[num2str(min(acquisitionTimes)) '-' num2str(max(acquisitionTimes)) ];
%     seriesTime=createSeriesDescriptionString({num2str(round(str2double([currCube.SeriesTime{:}])))});
    cubeSizeString=createCubeSizeString(cubeSizeFormatString,currCube.cube);
   
    nrString=sprintf('%3.3s: ',num2str(index));
    s=sprintf(formatString,...
        nrString,seriesDescription,cubeSizeString,timeString,studyDate,patientName);
    display([s '']);
    
end
display([lineString '']);
display(' ');


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

