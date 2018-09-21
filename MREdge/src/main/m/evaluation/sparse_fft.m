function [k_it, ] = sparse_fft(waveObs, mask, lambda, alpha)
%SPARSE_FFT Summary of this function goes here
%   Detailed explanation goes here

distVec = zeros(itSteps,1);
k_it = zeros(size(waveObs));


for step = 1:itSteps
    
    update = real(ifft2(mask.*fft2(k_it) - wave_obs)) + lambda*sign(k_it);
    k_it = k_it - alpha*update;
    k_it = k_it.*(abs(k_it) >= t);
    
    distVec(step) = norm(flip_for_fft(k_it, "back") - k_mat);
    
end



outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

