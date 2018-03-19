function [ complexDataCube ] = createComplexDataCubeFromMagnitudeAndPhase( magnDataCube,phaseDataCube)
%CREATECOMPLEXDICOMO Summary of this function goes here
%   Detailed explanation goes here

import mre_import.mre_import_helper.*;

complexDataCube=getEmptyComplexMreCubeStruct();

complexDataCube.fullPath.phase=phaseDataCube.fullPath;
complexDataCube.info.phase={phaseDataCube.info};
if isempty(magnDataCube)
    complexDataCube.cube=exp(1i*phaseDataCube.cube);
else
    complexDataCube.fullPath.magn=magnDataCube.fullPath;   
    complexDataCube.info.magn={magnDataCube.info};
    complexDataCube.cube=magnDataCube.cube.*exp(1i*phaseDataCube.cube);
end

% complexDataCube=autoExtractMetaInformationFromDicomHeaders( complexDataCube );

end

