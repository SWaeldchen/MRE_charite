function [ unwrapped_corr ] = fullDataOffsetCorrection( unwrapped,info )
%UNTITLED firstHarmCorr of this function goes here
%   Detailed explanation goes here


si=size(unwrapped);


unwrapped_corr=zeros(si);

for f=1:si(6)
    cycle=info.mechCycleTimes_us(f);
    for d=1:si(5)
      for t=1:si(4)
        for z=1:si(3)
            timeOffset=info.timeCorrectionForSlices_us(z,d,f);
            unwrapped_corr(:,:,z,t,d,f) = angle(exp(1i*unwrapped(:,:,z,t,d,f)).*exp(-1i*2*pi*timeOffset/cycle));
        end        
      end
    end
end


end

