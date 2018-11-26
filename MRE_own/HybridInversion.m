%% Set parameters

%%% All physical parameters

rho     = 1;
omega1   = 10;
omega2   = 14;

%%% All numerical parameters

resol = 20;
gridSize = resol*max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;
level = ceil(log2(gridSize));

%%% Physical and numerical values

D1 = deltaX^2*rho*omega1^2;
D2 = deltaX^2*rho*omega2^2;
muVec = mu_func(xVec)';

%% Calculating the displacement

%u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
%u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

u1 = invert_for_u(muVec, D1, 1+1j, 1-1j, gridSize);
u2 = invert_for_u(muVec, D2, 1+1j, 1-1j, gridSize);

%%%% Corrupt the displacement field

snr = 1000;
muNoise = muVec + max(muVec)*randn(size(muVec))/snr;

%% Denoising Mu

%muIt = wlet_denoise(muNoise, level, 'db6', 0, 0, 8);

%plot(xVec, muVec, 'b', xVec, muNoise, 'r', xVec, muIt, 'g');
%return

muIt = muNoise;

numofInvSteps = 6;

for step = 1:numofInvSteps
    
    step
    u1_mu = invert_with_u_and_mu(muIt, u1, D1, gridSize);
    u2_mu = invert_with_u_and_mu(muIt, u2, D2, gridSize);
    
    u1-u1_mu
    
    muIt = abs(invert_for_mu_split_u(D1, D2, u1_mu, u2_mu, u1_mu, u2_mu, gridSize));
    
    %muIt = wlet_denoise(muIt, level, 'db1', 0, 0, 8);
    
end

plot(xVec, muVec, 'b', xVec, muNoise, 'r', xVec, muIt, 'g', xVec, u1, '-');

%     u1_mu = invert_with_u_and_mu(muIt, u1, D, gridSize);
%     u2_mu = invert_with_u_and_mu(muIt, u2, D, gridSize);

%level = ceil(log2(gridSize));

% [u1Denoised, bestThresh] = find_right_thresh( u1, u1Noise, level )
% 
% return
%u1Denoised = wlet_denoise(u1Noise, level, 'db10', 0, 0, 7);
%u2Denoised = wlet_denoise(u2Noise, level, 'db10', 0, 0, 7);

% u1Denoised = wlet_denoise(real(u1Noise), level, 'db10', 0, 0, 7) + 1j*wlet_denoise(imag(u1Noise), level, 'db10', 0, 0, 7);
% u2Denoised = wlet_denoise(real(u2Noise), level, 'db10', 0, 0, 7) + 1j*wlet_denoise(imag(u2Noise), level, 'db10', 0, 0, 7);


% plot(xVec, u1, xVec, u1Denoised)

%plot(xVec, u1, 'b', xVec, u1Noise, 'r', xVec, u1Denoised, 'g', xVec, muVec-5, 'b');
% return

% plot(xVec, u1, 'b', xVec, u1Denoised, 'r', ...
%     xVec(2:end), 20*diff(u1)-5, 'b', xVec(2:end), 20*diff(u1Denoised)-5, 'r');
%    xVec(3:end), 200*diff(diff(u1))-10, 'b', xVec(3:end), 200*diff(diff(u1Denoised))-10, 'r');
% return

%% Reconstructing Mu

%%% Simple reconstruction

% muRec = abs(invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize));
% muRec = wlet_denoise(muRec, level, 'db1', 0, 0, 8);

% plot(xVec, muVec, 'b', xVec, muRec, 'r')
% 
% return
% 
% %%% Iterate Reconstruction
% 
% 
% 
% 
% muRec2 = iterate_mu(u1Denoised, u2Denoised, D1, D2, gridSize);
% muRec2 = wlet_denoise(muRec2, level, 'db1', 0.97, 0, 0);
% 
% norm(muVec-muRec2,1)/norm(muVec-muRec,1)
% max(abs(muVec-muRec2))/max(abs(muVec-muRec))
% 
% plot(xVec, muVec, 'b', xVec, muRec, 'r', xVec, muRec2, 'g')

% return
