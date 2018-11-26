


u1Denoised2 = wlet_denoise(u1Noise, level, 'db10', 0, 0, 6);
u2Denoised2 = wlet_denoise(u2Noise, level, 'db10', 0, 0, 6);

% u1Denoised2 = wlet_denoise(u1Noise, level, 'db10', 0, 0.005, 0);
% u2Denoised2 = wlet_denoise(u2Noise, level, 'db10', 0, 0.005, 0);


% plot(xVec(1:end), u1, xVec(1:end), u1Denoised2, ...
%      xVec(2:end), 100*diff(u1), xVec(2:end), 100*diff(u1Denoised2))

muRec2 = invert_for_mu(D1, D2, u1Denoised2, u2Denoised2, gridSize);

plot(xVec, muVec, xVec, muRec2)