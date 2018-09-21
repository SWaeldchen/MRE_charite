
%%% Orts-Dimension
l_x = 51;
l_y = 51;

% frequencies in the wave

freqList = { [1,1,1], [1,-3,1] };
k_mat = build_k_mat(freqList, l_x, l_y);

%%% Full Wave field:
wave = real(fft2(full(ifftshift(k_mat))));

%%% Indicator function of the observed space
%%% choose "rectangle" or "ellipse"
mask = geo_mask(l_x, l_y, 4, 26, 10, 28, "ellipse");

%%% Our observation with noie
sigma = 1;
wave_obs = mask.*(wave + sigma*randn(l_x,l_y));

%wave_obs(:,24:25) = 0;

%%%Our naive inverse fourier result:
k_naive = fftshift(abs(ifft2(wave_obs)));

%%%  Iteration settings

settings.numofSteps = 5000; % Numer of steps
settings.lambda = 0.005; % regularisation with 1-norm
settings.threshold = 0.00; % thresholding, leave at 0
settings.stepSize = 0.5; %step size 

[k_it, distVec] = cs_fftn(wave_obs, mask, settings);

%%% Plotting

figure

ax1 = subplot(2,3,1);
imagesc(wave);
title(ax1, 'real wave');

ax2 = subplot(2,3,2);
imagesc(wave_obs);
title(ax2, 'noisy observation');

ax3 = subplot(2,3,3);
plot(1:settings.numofSteps, distVec, 1:settings.numofSteps, norm(k_mat - k_naive)*ones(settings.numofSteps,1));
title(ax3, 'Convergence of CS-Algo');
legend('CS-Algo error','naive fft error');

ax4 = subplot(2,3,4);
imagesc(k_mat);
title(ax4, 'original k-space signal');

ax5 = subplot(2,3,5);
imagesc(k_naive);
title(ax5, 'naive reconstruction');

ax6 = subplot(2,3,6);
imagesc(k_it);
title(ax6, 'CS reconstruction');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [k_it, distVec] = cs_fftn(wave_obs, mask, settings)
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



function [k_mat] = build_k_mat(freqList, l_x, l_y)

numofFreq = length(freqList);

k_rows = zeros(2*numofFreq, 1);
k_cols = zeros(2*numofFreq, 1);
k_vals = zeros(2*numofFreq, 1);

for fr=1:numofFreq
    freq = freqList{fr};
    
    k_rows(fr) = freq(1) + ceil(l_x/2);
    k_rows(end-fr+1) = -freq(1) + ceil(l_x/2);
    
    k_cols(fr) = freq(2) + ceil(l_y/2);
    k_cols(end-fr+1) = -freq(2) + ceil(l_y/2);
    
    k_vals(fr) = freq(3);
    k_vals(end-fr+1) = freq(3);
    
end
k_mat = sparse(k_rows, k_cols, k_vals, l_x, l_y, 2*numofFreq);

end

function [mask] = geo_mask(l_x, l_y, start_x, stop_x, start_y, stop_y, shape)

mask = zeros(l_x, l_y);
if strcmp(shape, "rectangle")
    mask(round(start_x):round(stop_x), round(start_y):round(stop_y)) = 1;
elseif strcmp(shape, "ellipse")
    
    x = (1:l_x)';
    y = 1:l_y;
    c_x = ceil((stop_x + start_x)/2);
    c_y = ceil((stop_y + start_y)/2);
    w_x = ceil((stop_x - start_x)/2);
    w_y = ceil((stop_y - start_y)/2);

    mask( (x-c_x).^2/w_x.^2 + (y-c_y).^2/w_y.^2 <= 1) = 1;
end
    
end
