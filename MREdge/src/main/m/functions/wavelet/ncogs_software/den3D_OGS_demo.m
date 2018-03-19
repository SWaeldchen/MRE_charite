addpath allcode

brainUnwrapped = load('brain-unwrap-fft.mat');
brain = brainUnwrapped.brain;
szb = size(brain);
brain = extendZ(brain, szb(1));
denBrainR = denC3D_EB(real(brain), 0.3);
denBrainI = denC3D_EB(imag(brain), 0.3);
samples = 3;
figure(1)
clf
for n = 1:samples
    subplot(samples, 2, 2*(n-1)+1), imagesc(real(brain(:,:,2*n))), colormap(gray(256));
    subplot(samples, 2, 2*(n-1)+2), imagesc(denBrainR(:,:,2*n)), colormap(gray(256));
end
denBrain = denBrainR(:,:,szb(3):2*szb(3)-1) + 1i*denBrainI(:,:,szb(3):2*szb(3)-1);

orient tall
print -dps soft


%% try OGS in pace of soft thresholding

addpath ncogs_software;

K = [3 3 3];
lam = 0.04;
denBrainR = denC3D_EB_OGS(real(brain), K, lam);
denBrainI = denC3D_EB_OGS(imag(brain), K, lam);

samples = 3;
figure(2)
clf
for n = 1:samples
    subplot(samples, 2, 2*(n-1)+1), imagesc(real(brain(:,:,2*n))), colormap(gray(256));
    subplot(samples, 2, 2*(n-1)+2), imagesc(denBrainR(:,:,2*n)), colormap(gray(256));
end
title(sprintf('lam = %.3f', lam))
denBrain2 = denBrainR(:,:,szb(3):2*szb(3)-1) + 1i*denBrainI(:,:,szb(3):2*szb(3)-1);

orient tall
print -dps ogs3


% note: should try to use same color limits to compare results (to do..)





