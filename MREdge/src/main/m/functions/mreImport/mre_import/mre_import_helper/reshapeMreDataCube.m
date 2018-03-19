function [ reshapedMreDataCube ] = reshapeMreDataCube( mreDataCube,nSlices,...
                                             timeStepIndices,...
                                             motionDirs,...
                                             mechCycleTimes_us)
%ADDMREINFORMATION Summary of this function goes here
%   Detailed explanation goes here


reshapedMreDataCube=mreDataCube;

dirMatrixSize=size(motionDirs);
if dirMatrixSize(1)~=3
    error('Invalid motion encoding direction matrix!');
end

nDirections=dirMatrixSize(2);
nFrequencies=length(mechCycleTimes_us);

nTimeSteps=max(timeStepIndices(:));    

si=[size(mreDataCube.cube) 1];

totalNumberOfImages=prod(si(3:end));
numberOfImagesForAllFrequencies=nSlices*nTimeSteps*nDirections*nFrequencies;
if mod(totalNumberOfImages,numberOfImagesForAllFrequencies)~=0
    warning(['Invalid parameters: Total number of images is not an ' ... 
        'integer multiple of nSlices*nTimeSteps*nDirections*nFrequencies']);
    return;
end

numberOf6DCubes=totalNumberOfImages/numberOfImagesForAllFrequencies;


% if isscalar(timeSteps)
%     timeStepIndices=repmat(1:nTimeSteps,[1 nDirections*nFrequencies*numberOf6DCubes]);
% else
%     timeStepIndices=timeSteps;
% end

newSize=[si(1:2) nSlices nTimeSteps nDirections nFrequencies numberOf6DCubes];
reshapedMreDataCube.cube=reshape(mreDataCube.cube,newSize);
if isfield(reshapedMreDataCube,'timeCorrection_us')
    reshapedMreDataCube.timeCorrection_us=reshape(...
        reshapedMreDataCube.timeCorrection_us,...
        [nSlices nDirections nFrequencies numberOf6DCubes]);
end

reshapedMreDataCube.nSlices=nSlices;
reshapedMreDataCube.timeStepIndices=timeStepIndices(:);
reshapedMreDataCube.nTimeSteps=nTimeSteps;
reshapedMreDataCube.nDirections=nDirections;
reshapedMreDataCube.nFrequencies=nFrequencies;
reshapedMreDataCube.motionDirMatrix=motionDirs;
reshapedMreDataCube.mechCycleTimes_us=mechCycleTimes_us;
reshapedMreDataCube.mechFreq_Hz=1e6./reshapedMreDataCube.mechCycleTimes_us;





end

