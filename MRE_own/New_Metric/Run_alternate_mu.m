%% Set parameters

%%% All physical parameters

rho     = 1;
omega1   = 40;
omega2   = 50;

%%% All numerical parameters

resol = 20;
gridSize = resol*max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;
level = ceil(log2(gridSize));

%%% Physical and numerical values

sigma1 = deltaX^2*rho*omega1^2;
sigma2= deltaX^2*rho*omega2^2;
muVec = mu_func(xVec)'; %+ 0.01*randn(size(xVec));

%% Calculating the displacement

u1 = invert_for_u(muVec, sigma1, [1, 1]);
u2 = invert_for_u(muVec, sigma2, [1, 1]);

%% Add the Noise

snr = 10;

u1Noise = u1 + abs(hilbert(u1)).*randn(size(u1))/snr;
u2Noise = u2 + abs(hilbert(u2)).*randn(size(u2))/snr;

SNR = 10*log10(norm(u1)^2) - 10*log10(norm(u1 - u1Noise)^2)

% plot(xVec, u1, xVec, abs(hilbert(u1)), xVec, u1Noise)
% return

%plot(xVec, u1, xVec, u2);

%u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

%% Denoising u

u1Denoised = wlet_denoise(real(u1Noise), level, 'db10', 0, 0.1, 0); % + 1j*wlet_denoise(imag(u1Noise), level, 'db10', 0, 0, 7);
u2Denoised = wlet_denoise(real(u2Noise), level, 'db10', 0, 0.1, 0); % + 1j*wlet_denoise(imag(u2Noise), level, 'db10', 0, 0, 7);

% plot(xVec, u1, xVec, u1Noise+2, xVec, u1Denoised)
% return


%% Denoising Mu

%muIt = wlet_denoise(muNoise, level, 'db6', 0, 0, 8);

%plot(xVec, muVec, 'b', xVec, muNoise, 'r', xVec, muIt, 'g');
%return

% M1 = eye(gridSize-2);
% M2 = eye(gridSize-2);


%M2 = M2(:,2:end-1);


itSteps = 10;
lambda1 = 40; % > 0.005 otherwise numerical issues
lambda2 = 5;

muReg = ones(length(muVec),1);

M1 = waveOp_for_u(muReg, sigma1);
M2 = waveOp_for_u(muReg, sigma2);
    

for step = 1:itSteps
    
%     M1 = waveOp_for_u(muReg, sigma1);
%     M2 = waveOp_for_u(muReg, sigma2);
%     
    step

    muAlt = alt_invert_for_mu_3 (u1Noise, u2Noise, sigma1, sigma2, M1, M2, muReg, lambda1);
    
    muReg = reg_invert_for_mu(muAlt, lambda2);
    
    div = norm(muVec - muReg)
    
end


plot(xVec, muVec, xVec, muAlt, xVec, muReg);