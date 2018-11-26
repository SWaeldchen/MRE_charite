clear;

%% Set parameters

%%% All physical parameters

rho     = 1;
omega1   = 50;
omega2   = 40;

%%% All numerical parameters

resol = 20;
gridSize = resol*max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;

%%% Physical and numerical values

D1 = deltaX^2*rho*omega1^2;
D2 = deltaX^2*rho*omega2^2;
muVec = mu_func(xVec)';

%% Calculating the displacement

%u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
%u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

u1 = (invert_for_u(muVec, D1, 1, 1, gridSize));
u2 = (invert_for_u(muVec, D2, 1, 1, gridSize));

%%%% Corrupt the displacement field

snr = 10;
u1Noise = u1 + max(u1)*randn(size(u1))/snr;
u2Noise = u2 + max(u2)*randn(size(u2))/snr;

%% Denoising U




level = ceil(log2(gridSize));

% [u1Denoised, bestThresh] = find_right_thresh( u1, u1Noise, level )
% 
% return
%u1Denoised = wlet_denoise(u1Noise, level, 'db10', 0, 0, 7);
%u2Denoised = wlet_denoise(u2Noise, level, 'db10', 0, 0, 7);

u1Denoised = wlet_denoise(real(u1Noise), level, 'db10', 0.96, 0, 2); % + 1j*wlet_denoise(imag(u1Noise), level, 'db10', 0, 0, 4);
u2Denoised = wlet_denoise(real(u2Noise), level, 'db10', 0.96, 0, 2); % + 1j*wlet_denoise(imag(u2Noise), level, 'db10', 0, 0, 4);


% plot(xVec, u1, xVec, u1Denoised)

%plot(xVec, u1, 'b', xVec, u1Noise, 'r', xVec, u1Denoised, 'g', xVec, muVec-5, 'b');
% return

% plot(xVec, u1, 'b', xVec, u1Denoised, 'r', ...
%     xVec(2:end), 20*diff(u1)-5, 'b', xVec(2:end), 20*diff(u1Denoised)-5, 'r');
%    xVec(3:end), 200*diff(diff(u1))-10, 'b', xVec(3:end), 200*diff(diff(u1Denoised))-10, 'r');
% return

%% Reconstructing Mu

%%% Simple reconstruction

muRec = abs(invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize));
muRec = wlet_denoise(muRec, level, 'db1', 0, 0, 3);

plot(xVec, muVec, 'b', xVec, muRec, 'r')

return

%%% Iterate Reconstruction

muRec2 = iterate_mu(u1Denoised, u2Denoised, D1, D2, gridSize);
%muRec2 = wlet_denoise(muRec2, level, 'db1', 0.97, 0, 0);

norm(muVec-muRec2,1)/norm(muVec-muRec,1)
max(abs(muVec-muRec2))/max(abs(muVec-muRec))

plot(xVec, muVec, 'b', xVec, muRec, 'r', xVec, muRec2, 'g')

% return

