function [bestUDenoised, bestThresh] = find_right_thresh( u, uNoise, level )
%FIND_RIGHT_THRESH Summary of this function goes here
%   Detailed explanation goes here

bestUDenoised = zeros(size(u));
bestThresh = 0;

for thresh = 0:0.0005:0.05
    
    uDenoised = wlet_denoise(uNoise, level, 'db10', 0, thresh, 0);
   
    
    
    if norm(u-uDenoised)<norm(u-bestUDenoised)
        bestUDenoised = uDenoised;
        bestThresh = thresh;
    end
end

end

