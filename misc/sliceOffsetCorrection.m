function [ firstHarmCorr ] = sliceOffsetCorrection( firstHarmonic,mreInfo )
%UNTITLED firstHarmCorr of this function goes here
%   Detailed explanation goes here


si=size(firstHarmonic);


firstHarmCorr=zeros(si);

for fIndex=1:si(5)
    cycle=mreInfo.mechCycleTimes_us(fIndex);
    for dIndex=1:si(4)
        for slIndex=1:si(3)
            timeOffset=mreInfo.timeCorrectionForSlices_us(slIndex,dIndex,fIndex);
            firstHarmCorr(:,:,slIndex,dIndex,fIndex)=firstHarmonic(:,:,slIndex,dIndex,fIndex)*exp(-1i*2*pi*timeOffset/cycle);
        end
    end
end


end

