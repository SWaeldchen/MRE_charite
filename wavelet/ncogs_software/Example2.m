%% Group-sparse denoising by non-convex regularization: Speech denoising
% This example illustrates speech denoising using 2D overlapping
% group sparsity (OGS) with a non-convex regularizer (the 'atan' function). 
% 2D OGS is applied to the spectrogram.
%
% Po-Yu Chen and Ivan Selesnick, August 2013
%
% Reference: Group-Sparse Signal Denoising: Non-Convex Regularization, Convex Optimization 
% http://arxiv.org/abs/1308.5038


%% Set up

close all
clear all

printme = @(txt) ...
   print('-dpdf', sprintf('figures/Example2_%s', txt));

%% Load speech signal

[x, Fs] = wavread('arctic_a0001.wav');

x = x(:)';              % Convert to row vector

N = length(x);          % N : signal length

T = N/Fs;               % T : signal duration (sec)

%% Make noisy signal

% snr_dB : SNR level of noisy signal (dB)
snr_dB = 10;                    
snr = 10^(snr_dB/10);

Px = var(x) + mean(x)^2;
Pn = Px/snr;

% sigma_n : standard deviation of noise
sigma_n = sqrt(Pn);             

% Set state for reproducibility of example
randn('state', 0);              

% y : noisy speech signal
y = x + sigma_n * randn(1, N);  

%% Define STFT function

Nf = 2^9;                       % FFT length
F = @(y) stft(y, Nf);           % STFT
invF = @(c) istft(c, Nf, N);    % inverse STFT

Y = F(y);    % Y : STFT of noisy speech signal
X = F(x);    % X : STFT of clean speech signal

%% STFT of noisy speech

dBlim = [-50 0];

figure(1)
clf
displaySTFT(Y, Fs, T, dBlim)
title( sprintf('Noisy signal (SNR = %2.0f dB)', ...
    get_snr(x, y)) )
printme('noisy')

% sigma_stft: noise standard deviation in STFT domain
sigma_stft = sigma_n/sqrt(2);    


%% Soft thresholding

% Calculate lambda by table look up and interpolation
stdo = 3E-4;

% Group size of 1 by 1 (scalar)
lam_factor = find_lam(stdo, 'abs', 'complex', 1, 1);  
lam = lam_factor * sigma_stft;

X_soft = soft(Y, lam);
x_soft = real(invF(X_soft));

% Compute SNR
snr_soft = get_snr(x, x_soft); 
fprintf('Soft thresholding: SNR = %.2f dB\n', snr_soft)

%%  
% Display the spectrogram

figure(1)
clf
displaySTFT(X_soft, Fs, T, dBlim)
tstr = sprintf('soft (SNR = %3.2f dB, \\lambda = %3.2f\\sigma)', ...
    snr_soft, lam_factor);
title( tstr );
printme('soft')


%% OGS[abs]

% (K1, K2) : Two-dimensional group size in STFT domain
K1 = 8;     % K1 : number of spectral samples
K2 = 2;     % K2 : number of temporal samples

Nit = 25;   % Nit : number of iterations of OGS algorithm

% Calculate lambda by table look up and interpolation
stdo = 3E-4;
lam_factor = find_lam(stdo, 'abs', 'complex', K1, K2);
lam = lam_factor * sigma_stft;

% Run OGS[abs] algorithm
X_ogs_abs = ogs2(Y, K1, K2, lam, 'abs', 0, Nit);

% inverse STFT
x_ogs_abs = real(invF(X_ogs_abs));                  

% Compute SNR
snr_ogs_abs = get_snr(x, x_ogs_abs); 
fprintf('OGS[abs]: SNR = %.2f dB\n', snr_ogs_abs)

%%
% Spectrogram

figure(3)
clf
displaySTFT(X_ogs_abs, Fs, T, dBlim)
tstr = sprintf('OGS[abs] (SNR = %3.2f dB, \\lambda = %3.2f\\sigma, %d iterations)', ...
    snr_ogs_abs, lam_factor, Nit);
title( tstr );
printme('ogs_abs')


%% OGS[atan]

% Calculate lambda by table look up and interpolation
stdo = 3E-4;
lam_factor = find_lam(stdo, 'atan', 'complex', K1, K2);    
lam = lam_factor * sigma_stft;

% Run OGS[tan] algorithm
X_ogs_atan = ogs2(Y,  K1, K2, lam, 'atan', 1, Nit);

% inverse STFT
x_ogs_atan = real(invF(X_ogs_atan));

% Compute SNR
snr_ogs_atan = get_snr(x, x_ogs_atan);
fprintf('OGS[atan]: SNR = %.2f dB\n', snr_ogs_atan)

%%
% Spectrogram

figure(4)
clf
displaySTFT(X_ogs_atan, Fs, T, dBlim)
tstr = sprintf('OGS[atan] (SNR = %3.2f dB, \\lambda = %3.2f\\sigma, %d iterations)', ...
    snr_ogs_atan, lam_factor, Nit);
title( tstr )
printme('ogs_atan')

%% SNR summary

fprintf('\n')
fprintf('Summary:\n')
fprintf('Soft thresholding: SNR = %.2f dB\n', snr_soft)
fprintf('OGS[abs]: SNR = %.2f dB\n', snr_ogs_abs)
fprintf('OGS[atan]: SNR = %.2f dB\n', snr_ogs_atan)

%% Listen to results
% Uncomment following lines to hear the denoised speech signals.

% sound(x_soft, Fs);
% 
% sound(x_ogs_abs, Fs);
% 
% sound(x_ogs_atan, Fs);


%% Wiener post-processing
% For this example, Wiener post-processing improves soft-thresholding and OGS[abs]
% but it does not improve OGS[atan].

% soft thresholing
X_soft_wp = Y .* abs(X_soft).^2 ./ ( abs(X_soft).^2 + sigma_stft^2 );   
x_soft_wp = invF(X_soft_wp);

% OGS[abs]
X_ogs_abs_wp = Y .* abs(X_ogs_abs).^2 ./ ( abs(X_ogs_abs).^2 + sigma_stft^2 );   
x_ogs_abs_wp = invF(X_ogs_abs_wp);

% OGS[atan]
X_ogs_atan_wp = Y .* abs(X_ogs_atan).^2 ./ ( abs(X_ogs_atan).^2 + sigma_stft^2 );
x_ogs_atan_wp = invF(X_ogs_atan_wp);

% Compute SNR values
snr_soft_wp = get_snr(x, x_soft_wp);
snr_ogs_abs_wp = get_snr(x, x_ogs_abs_wp);
snr_ogs_atan_wp = get_snr(x, x_ogs_atan_wp);

% Display SNR values
fprintf('\n')
fprintf('With Wiener post-processing:\n')
fprintf('Soft thresholding: SNR = %.2f dB\n', snr_soft_wp)
fprintf('OGS[abs]: SNR = %.2f dB\n', snr_ogs_abs_wp)
fprintf('OGS[atan]: SNR = %.2f dB\n', snr_ogs_atan_wp)


