function [k_it, distVec] = cs_fft(wave_obs, mask, settings)
%CS_FFT Summary of this function goes here
%   Detailed explanation goes here


numofSteps = settings.numofSteps; % Numer of steps
lambda = settings.lambda; % regularisation with 1-norm
t = settings.threshold; % thresholding
alpha = settings.stepSize; %step size 

k_it = zeros(size(wave_obs)); % starting point
k_it_last = k_it;
distVec = zeros(numofSteps,1);

for step = 1:numofSteps
    
    update = real(ifftn(mask.*fftn(k_it) - wave_obs)) + lambda*sign(k_it);
    k_it = k_it - alpha*update;
    k_it = k_it.*(abs(k_it) >= t);
    
    distVec(step) = norm(k_it - k_it_last);
    k_it_last = k_it;
    
end

k_it = flip_for_fft(k_it, "back");



end

