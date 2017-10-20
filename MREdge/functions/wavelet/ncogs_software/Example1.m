%% Group-sparse denoising by non-convex regularization: 1D example
% This example illustrates 1D signal denoising using overlapping
% group sparsity (OGS) with a non-convex regularizer (the 'atan' function). 
% Although the regularizer is non-convex, it is chosen such that
% the total cost function is convex. The comparison to convex-regularized
% OGS demonstrates the improvement obtained by non-convex regularization.
%
% Po-Yu Chen and Ivan Selesnick, August 2013
%
% Reference: 'Group-Sparse Signal Denoising: Non-Convex Regularization,
% Convex Optimization'
% http://arxiv.org/abs/1308.5038

%% Set up

clear all
close all

printme = @(txt) ...
   print('-dpdf', sprintf('figures/Example1_%s', txt));


%% Make signals

% N : length of signal
N = 100;                     

% x : noise-free signal
x = zeros(N,1);              
x(20+(-3:3)) = [2 3 4 5 4 3 2];
x(40+(-3:3)) = [3 -2 -4 5 2 4 -3];
x(60+(-3:3)) = [3 4 2 5 -4 -2 -3];
x(80+(-3:3)) = [3 -4 -2 5 4 2 -3];

% Set state for reproducibility
randn('state', 0)               

% y : signal + noise
y = x + (2/3) * randn(N, 1);

snr_y = get_snr(x, y);


%% Plot signals

ylim1 = [-8 8];

figure(1)
clf
subplot(2, 1, 1)
stem(x, 'marker', 'none')
ylim(ylim1);
title('Signal');

subplot(2, 1, 2)
stem(y, 'marker', 'none')
title(sprintf('Signal + noise (SNR = %3.2f dB)', snr_y));
ylim(ylim1);
xlabel('n')
printme('data')


%% Denoising using the soft threshold
% Compute SNR as a function of lambda.

L = 50;
lam = linspace(0.01, 0.8, L);
SNR = zeros(1, L);

for i = 1:L
    f = soft(y, lam(i));
    SNR(i) = get_snr(x, f); 
end

figure(1)
clf
plot(lam, SNR)
xlabel('\lambda')
title('Soft-thresholding')
ylabel('SNR (dB)')

%%
% Find the lambda that maximizes the SNR.

[~, k] = max(SNR);
lam_soft = lam(k);
x_soft = soft(y,  lam_soft);
snr_soft = get_snr(x, x_soft);

figure(2)
clf
subplot(2, 1, 1)
stem(x_soft, 'marker', 'none')
ylim(ylim1);
title(sprintf('Soft thr. (SNR = %3.2f dB)', snr_soft));
text(5, -6, sprintf('\\lambda = %3.2f', lam_soft))
xlabel('n')
printme('soft')


%% Denoising using OGS[abs]
% Compute SNR as a function of lambda.

K = 5;             % K : group size
Nit = 30;          % Nit : number of iterations. 

lam = linspace(0.01, 0.3, L);
SNR = zeros(1, L);
pen = 'abs';
rho = 0;
for i = 1:L
    f = ogs1(y, K, lam(i), pen, rho, Nit);
    SNR(i) = get_snr(x, f);    
end

figure(1)
clf
plot(lam, SNR)
xlabel('\lambda')
title('OGS[abs]')
ylabel('SNR (dB)')

%%
% Find the lambda that maximizes the SNR.

[~, k] = max(SNR);
lam_abs = lam(k);
[x_abs, cost_abs] = ogs1(y, K, lam_abs, 'abs', 0, Nit);
snr_abs = get_snr(x, x_abs);

figure(2)
clf
subplot(2, 1, 1)
stem(x_abs, 'marker', 'none')
ylim(ylim1);
title(sprintf('OGS[abs] (SNR = %3.2f dB)', snr_abs));
text(5, -6, sprintf('\\lambda = %3.2f, K = %d', lam_abs, K));
xlabel('n')
printme('ogs_abs')


%% Denoising using OGS[atan]
% Compute SNR as a function of lambda.

lam = linspace(0.01, 0.8, L);
pen = 'atan';
SNR = zeros(1, L);

for i = 1:L
    f = ogs1(y, K, lam(i), pen, 1, Nit);
    SNR(i) = get_snr(x, f);    
end

figure(1)
clf
plot(lam, SNR)
xlabel('\lambda')
title('OGS[atan]')
ylabel('SNR (dB)')

%%
% Find the lambda that maximizes the SNR.

[~, k] = max(SNR);
lam_atan = lam(k);
[x_atan, cost_atan] = ogs1(y, K, lam_atan, 'atan', 1, Nit);
snr_atan = get_snr(x, x_atan);

figure(2)
subplot(2, 1, 1)
stem(x_atan, 'marker', 'none')
ylim(ylim1);
title(sprintf('OGS[atan] (SNR = %3.2f dB)', snr_atan));
text(5, -6, ...
    sprintf('\\lambda = %3.2f, K = %d', lam_atan, K))
xlabel('n')
printme('ogs_atan')



%% Input-output graph

figure(3)
clf
h = plot( abs(y), abs(x_atan), 'ko', ...
    abs(y), abs(x_abs), 'kx' );
set(h(1), 'markersize', 5)
set(h(2), 'markersize', 4)
line([0 5], [0 5], 'linestyle', ':', 'color', 'black')
axis square
xlabel('y')
ylabel('x')
title('Output versus input');

legend(h, 'OGS[atan]', 'OGS[abs]')
legend(h, 'location', 'southeast')

printme('Input_Output')


%% Sorted error functions

err_abs = x - x_abs;
err_atan = x - x_atan;

figure(4)
clf
n = 1:N;
plot(n, sort(abs(err_abs), 'descend'), '--', ...
    n, sort(abs(err_atan), 'descend'))
ylim([0 1.25])
xlabel(' ')
legend('OGS[abs]', 'OGS[atan]', 'location', 'east')
title('Sorted error');
printme('sorted_error')


