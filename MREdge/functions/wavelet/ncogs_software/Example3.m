%% NCOGS Example 3 (3D group-sparse shrinkage)
% This example illustrates 3D sparse signal denoising using non-convex
% overlapping group sparsity (OGS).
%
% Ivan Selesnick, July 2014
%
%  Reference:
% Group-Sparse Signal Denoising: Non-Convex Regularization, Convex Optimization 
% Po-Yu Chen and Ivan Selesnick 
% IEEE Transactions on Signal Processing, vol.62, no.13, pp. 3464-3478, July 1, 2014. 
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6826555&isnumber=6826603
%
% Preprint: http://arxiv.org/abs/1308.5038

%% Set up

clear all
close all

% Set state for reproducibility
rng('default')
rng(1);

rmse = @(err) sqrt(mean(abs(err(:)).^2));

%% Make data

% N : size of 3D data
N = [30, 40, 20];

% x : noise-free data
x = zeros(N);              
x(10+[1:4], 10+[1:4], 10+[1:4]) = rand(4,4,4)-0.5;
x(15+[1:4], 25+[1:4], 8+[1:4]) = rand(4,4,4)-0.5;

% y : noisy data
sigma = 0.1;
y = x + sigma * randn(N);

%% Denoising using OGS

Nit = 30;          % Nit : number of iterations. 

K = [3 3 3];       % K : group size
% Note: the group size does not need to be the same as
% the true groups in the data. Usually, the specified
% group size should be smaller. (Also, in many real data,
% groups are of different sizes anyway, there is not
% single group size to identify.)

% OGS[abs]
pen = 'abs';
rho = 0;
lam_abs = 0.020;
[f_abs, cost_abs] = ogs3(y, K, lam_abs, pen, rho, Nit);
rmse(f_abs - x)

% OGS[atan]
pen = 'atan';
rho = 1;
lam_atan = 0.023;
[f_atan, cost_atan] = ogs3(y, K, lam_atan, pen, rho, Nit);
rmse(f_atan - x)

%% Display 2D slices
% Show 2D slices through the data as images

Clim = [-1 1]/2;

set(0, 'DefaultAxesFontSize', 8);

figure(1)
clf

subplot(2, 2, 1)
imagesc(x(:,:,11), Clim)
% colorbar
axis image
title('Noise-free data');
colormap(gray(256))
axis off

subplot(2, 2, 2)
imagesc(y(:,:,11), Clim)
title(sprintf('Noisy data (sigma = %3.2f )', sigma));
% colorbar
axis image
axis off

subplot(2, 2, 3)
imagesc(f_abs(:,:,11), Clim)
title(sprintf('Denoised using OGS[abs] (\\lambda = %.2e )', lam_abs));
% colorbar
axis image
axis off

subplot(2, 2, 4)
imagesc(f_atan(:,:,11), Clim)
title(sprintf('Denoised using OGS[atan] (\\lambda = %.2e )', lam_atan));
% colorbar
axis image
axis off

orient landscape
print -dps figures/Example3_fig1

set(0, 'DefaultAxesFontSize', 'remove');


%% Display 1D lines
% Display 1D lines through the data as plots.
% It can be seen that OGS[abs] substantially underestimates the data (as
% would soft thresholding). OGS[atan] estimates the data more accurately.

figure(2)

subplot(2, 2, 1)
plot(x(:,26,11))
title('Noise-free data');
ylim(Clim)

subplot(2, 2, 2)
plot(y(:,26,11))
title(sprintf('Noisy data (sigma = %3.2f )', sigma));
ylim(Clim)

subplot(2, 2, 3)
plot(f_abs(:,26,11))
title(sprintf('Denoised using OGS[abs] (\\lambda = %.2e )', lam_abs));
ylim(Clim)

subplot(2, 2, 4)
plot(f_atan(:,26,11))
title(sprintf('Denoised using OGS[atan] (\\lambda = %.2e )', lam_atan));
ylim(Clim)

orient landscape
print -dpdf figures/Example3_fig2



