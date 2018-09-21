function [u] = denoise_u_2d(u)
%DENOISE_U Summary of this function goes here
%   Detailed explanation goes here

[sz(1), sz(2), numofDir, numofFreq] = size(u);

mode = 'bwlow';

for freq = 1:numofFreq
   
    for dir = 1:numofDir
        
        
        u(:,:,dir, freq) = apply_denoise(u(:,:,dir, freq), mode);

        
        
        
    end
    
end


end


function [u] = apply_denoise(u, mode)


switch mode

    case 'bwlow'    %butterworth low pass filter
        u = butter_2d(10, 0.25, u, 0);
    otherwise
end %switch




end

