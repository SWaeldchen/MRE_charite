function [ normalizedCube ] = normalizePhaseDataToPlusMinusPi( dataCube )
%NORMALIZETOPLUSMINUSPI Summary of this function goes here
%   Detailed explanation goes here


import mre_import.mre_import_helper.*;


[ header ] = getDicomInfoCellArrayFromDataObject( dataCube );
info=header{1};
if ~getDicomHeaderInfo(info,'IsPhase')
    error('Argument is not a phase data cube.');
end

normalizedCube=dataCube;
normalizedCube.cube=(normalizedCube.cube-2048)/4096*2*pi;

end

