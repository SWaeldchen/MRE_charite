function [ complexMreDataCubes otherMagnitudeCubes ] = convertMreDataToComplexCubes( dataCubes )
%CONVERTMREDATATOCOMPLEXCUBES Summary of this function goes here
%   Detailed explanation goes here

import mre_import.mre_import_helper.*;

if isempty(dataCubes)
    complexMreDataCubes=[];
    otherMagnitudeCubes=[];
else

[ magnIndices phaseIndices ] = getMreSeriesIndices( dataCubes );

isMrePhase=false(size(dataCubes));
isMrePhase(phaseIndices)=true;
isMreMagn=false(size(dataCubes));
isMreMagn(magnIndices(magnIndices>0))=true;
isOtherMagn=~(isMrePhase|isMreMagn);

for index=phaseIndices
    [ normalizedCube ] = normalizePhaseDataToPlusMinusPi( dataCubes(index));
    dataCubes(index)=normalizedCube;
    dataCubes(index).dataType='PHASE';    
end

% complexMreDataCubes=dataCubes(phaseIndices);
for index=1:length(phaseIndices)
    phaseDataCube=dataCubes(phaseIndices(index));
    if magnIndices(index)<1
        [complexCube ] = createComplexDataCubeFromMagnitudeAndPhase( [],phaseDataCube);
    else
        [ complexCube ] = createComplexDataCubeFromMagnitudeAndPhase( dataCubes(magnIndices(index)),phaseDataCube);
    end
    complexMreDataCubes(index)=complexCube;
end

otherMagnitudeCubes=dataCubes(isOtherMagn);
for index=1:numel(otherMagnitudeCubes);
    otherMagnitudeCubes(index).dataType='MAGN';    
end

end
end

