function [ firstHarmCorr ] = sliceWisePhaseCorrection( firstHarmonic )
%SCRIPTFORJING Summary of this function goes here
%   Detailed explanation goes here




firstHarmCorr=firstHarmonic;
for index=1:length(firstHarmonic)
    si=size(firstHarmonic(index).cube);
    for fIndex=1:si(5)
        cycle=firstHarmonic(index).mechCycleTimes_us(fIndex);
        for dIndex=1:si(4)
            for slIndex=1:si(3)
                timeOffset=firstHarmonic(index).timeCorrectionForSlices_us(slIndex,dIndex,fIndex);
                firstHarmCorr(index).cube(:,:,slIndex,dIndex,fIndex)=firstHarmonic(index).cube(:,:,slIndex,dIndex,fIndex)*exp(-1i*2*pi*timeOffset/cycle);
            end
        end
    end
    
end


end

