function [ complexDataCube ] = getEmptyComplexMreCubeStruct()
%GETEMPTYCOMPLEXCUBESTRUCT Summary of this function goes here
%   Detailed explanation goes here


complexDataCube=struct();

complexDataCube.info.magn={};
complexDataCube.info.phase={};
complexDataCube.fullPath.magn={};
complexDataCube.fullPath.phase={};
complexDataCube.dataType='COMPLEX';
complexDataCube.cube=[];


end

