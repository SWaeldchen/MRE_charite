function [ magnIndices phaseIndices ] = getMreSeriesIndices( dataCubes )
%GETMRESERIESINDICES Summary of this function goes here
%   Detailed explanation goes here

import mre_import.mre_import_helper.*;

si=size(dataCubes);

isPhase=false(si);
isMagn=false(si);
studyInstanceUIDs=cell(si);
acquisitionTimes=cell(si);
for index=1:length(dataCubes)
    isPhase(index)=getDicomHeaderInfo(dataCubes(index).info,'IsPhase');
    isMagn(index)=getDicomHeaderInfo(dataCubes(index).info,'IsMagn');
    studyInstanceUIDs{index}=dataCubes(index).info.StudyInstanceUID;
    acquisitionTimes{index}=dataCubes(index).info.AcquisitionTime;
end


indices=1:length(dataCubes);
magnIndices=zeros(1,sum(isPhase));
phaseIndices=indices(isPhase);

mreCounter=0;
for index1=phaseIndices
    mreCounter=mreCounter+1;
    magnIndices(mreCounter)=0;
    for index2=indices(isMagn)
        if isequal(studyInstanceUIDs{index1},studyInstanceUIDs{index2}) ...
                && isequal(acquisitionTimes{index1},acquisitionTimes{index2})
            magnIndices(mreCounter)=index2;
        end
    end
end



end

