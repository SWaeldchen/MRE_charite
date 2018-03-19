function displayImageSeries( series )
%DISPLAYIMAGESERIES Summary of this function goes here
%   Detailed explanation goes here


% import mre_import.mre_import_helper.*;

formatString='%-25.25s %-30.30s %-30.30s %-30.30s %-15.15s %-15.15s';
s=sprintf(formatString,'     SER# (# files):',...
    'SERIES DESCRIPTION','IMAGE TYPE','PATIENT NAME','SERIES TIME','SERIES DATE');
display([s '']);

lineString=repmat('-',1,length(s));

display([lineString '']);
for index=1:length(series)
    currSeries=series{index};
    dicomHeader=currSeries(1).info;
    
    patientName=getDicomHeaderInfo(dicomHeader,'FullPatientName');
    seriesNumber=getDicomHeaderInfo(dicomHeader,'SeriesNumber');
    seriesDescription=getDicomHeaderInfo(dicomHeader,'SeriesDescription');
    seriesDate=getDicomHeaderInfo(dicomHeader,'SeriesDate');
    seriesTime=getDicomHeaderInfo(dicomHeader,'SeriesTime');
    numberOfInstances=length(currSeries);
    imageType=dicomHeader.ImageType;
    
    nrString=sprintf('%3.3s: %3.3s (%3.3s files)',num2str(index),...
        num2str(seriesNumber),num2str(numberOfInstances));
    s=sprintf(formatString,...
        nrString,seriesDescription,imageType,patientName,seriesTime,seriesDate);
    display([s '']);
    
end
display([lineString '']);
display(' ');


end

