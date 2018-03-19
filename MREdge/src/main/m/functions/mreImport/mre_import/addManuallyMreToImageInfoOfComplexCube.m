function [ complexCubeWithMreInfo ] = addManuallyMreToImageInfoOfComplexCube( complexCube,nTimeSteps,directions,cycleTimes_ms,nSessions,timeCorrection_us )
%ADDMANUALLYMRETOIMAGEINFOOFCOMPLEXCUBE Summary of this function goes here
%   Detailed explanation goes here

complexCubeWithMreInfo=complexCube;
infos=complexCube.ImageInfo;
if isfield(infos,'mre')
    warning('complexCube already contains mre information. Will be overwritten...');
end
sliceLocations=unique([infos.SliceLocation]);
nSlices=length(sliceLocations);
nDirections=size(directions,2);
nFreqs=size(cycleTimes_ms,2);


if (nSlices*nTimeSteps*nDirections*nFreqs*nSessions)~=numel(infos)
    error('Parameters do not match to the number of images.');
end

if nargin<6
    timeCorrection_us=zeros([nSlices nTimeSteps nDirections nFreqs nSessions]);
end


if size(directions,1)==1
    M=eye(3);
    dirVectors=zeros(3,nDirections);
    for index=1:nDirections
        if directions(index)<0
            dirVectors(:,index)=-M(:,-directions(index));
        else
            dirVectors(:,index)=M(:,directions(index));
        end
    end
else
    if size(directions,1)==3
        dirVectors=directions;
    else
        error('directions parameter must be 3-by-n or row vector with n elements!');
    end
end


counter=1;
for sessI=1:nSessions
    for freqI=1:nFreqs
        for dirI=1:nDirections
            for tsI=1:nTimeSteps
                for slI=1:nSlices
                    infos(counter).mre.mechCycleTime_us=1000*cycleTimes_ms(freqI);
                    infos(counter).mre.timeStepIndex=tsI-1;
                    infos(counter).mre.dirIndex=dirI-1;
                    infos(counter).mre.freqIndex=freqI-1;
                    infos(counter).mre.timeCorrectionForSlice_us=timeCorrection_us(slI,tsI,dirI,freqI,sessI);
                    infos(counter).mre.megVector=dirVectors(:,dirI);
                    counter=counter+1;
                end
            end
        end
    end
    
end


complexCubeWithMreInfo.ImageInfo=infos;


end

