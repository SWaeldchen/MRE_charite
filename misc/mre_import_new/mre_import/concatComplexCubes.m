function [ concatCube ] = concatComplexCubes( complexCubes,dimension )
%CONCATCOMPLEXCUBESVIAFREQDIMENSION Summary of this function goes here
%   Detailed explanation goes here


import mre_import.*;
import mre_import.mre_import_helper.*;

if nargin<2
    dimension=6;
end

if (dimension>7 || dimension<1)
    error('dimension parameter must be positive integer not greater than 7)!');
end


[ concatCube ] = concatDataCubes( complexCubes );
[ concatCube ] = autoExtractMetaInformationFromDicomHeaders( concatCube );
concatCube.ImageInfo=complexCubes(1).ImageInfo;
[ sortMatrix ] = getIdentitySortMatrixForComplexCube( complexCubes(1) );
colIndex=7-dimension+1;
for index=2:numel(complexCubes)
    maxIndex=max(sortMatrix(:,colIndex));
    [ sortMatrixToAdd ] = getIdentitySortMatrixForComplexCube( complexCubes(index) );
    sortMatrixToAdd(:,colIndex)=sortMatrixToAdd(:,colIndex)+maxIndex+1;
    sortMatrix=cat(1,sortMatrix,sortMatrixToAdd);
    concatCube.ImageInfo=cat(2,concatCube.ImageInfo,complexCubes(index).ImageInfo);
   
end


[ concatCube ] = sortAndReshapeMreCube( concatCube,sortMatrix );
[ concatCube ] = autoExtractMreInfoFromMreDataCube( concatCube );

end

