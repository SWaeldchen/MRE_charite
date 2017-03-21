function [ dataCubeWithSplitMosaics ] = splitAllMosaicDataCubes( dataCubes )
%SPLITALLMOSAICDATACUBES Summary of this function goes here
%   Detailed explanation goes here

import mre_import.mre_import_helper.*;
 
dataCubeWithSplitMosaics=dataCubes;

for index=1:length(dataCubes)
    header=getDicomInfoCellArrayFromDataObject(dataCubes(index));
    info=header{1};

    if getDicomHeaderInfo(info,'IsMosaic')
        dataCubeWithSplitMosaics(index)=splitMosaics( dataCubes(index) );
    end
%     dataCubeWithSplitMosaics{index}=autoExtractMetaInformationFromDicomHeaders(dataCubeWithSplitMosaics{index});

end

