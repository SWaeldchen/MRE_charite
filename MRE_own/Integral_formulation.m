%% Set parameters

%%% All physical parameters

rho     = 1;
omega1   = 20;
omega2   = 30;

%%% All numerical parameters

resol = 20;
gridSize = resol*max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;
level = fix(log2(gridSize));

%%% Physical and numerical values

D1 = deltaX^2*rho*omega1^2;
D2 = deltaX^2*rho*omega2^2;
muVec = mu_func(xVec)'; %gen_sparse_mu(gridSize, 100, 'db5'); %mu_func(xVec)';

%% Calculating the displacement

u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

%%%% Corrupt the displacement field

snr = 100;
u1Noise = u1 + max(u1)*randn(size(u1))/snr;
u2Noise = u2 + max(u2)*randn(size(u2))/snr;


%% Denoising U

u1Denoised = wlet_denoise(real(u1Noise), level, 'db10', 0, 0, 4) + 1j*wlet_denoise(imag(u1Noise), level, 'db10', 0, 0, 4);
u2Denoised = wlet_denoise(real(u2Noise), level, 'db10', 0, 0, 4) + 1j*wlet_denoise(imag(u2Noise), level, 'db10', 0, 0, 4);

% plot(xVec(1:end), (abs(u1)), xVec(1:end), (abs(u1Noise)), xVec(1:end), (abs(u1Denoised)));
% return

%% Denoising Mu


muRec = invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize);

%muIt = wlet_denoise(muNoise, level, 'db6', 0, 0, 8);

% plot(xVec, muVec, 'b', xVec, abs(muRec), 'r');
% return

muIt = abs(muRec);
muThresh = muIt;
muWithU = ones(gridSize,1); %invert_for_mu(D1, D2, u1Noise, u2Noise, gridSize);

% muWithUdirect = invert_for_mu(

numofInvSteps = 5000;
alpha = 0.01;
lambda = 0.01;

% wdecMat = gen_wave_mat(gridSize, 8, 'db10');
% save('WaveletMats','wdecMat');

wdecMat = load('WaveletMats', 'wdecMat');
wdecMat = wdecMat.wdecMat;

for step = 1:numofInvSteps
    
    step
    
    muWithU(50)
    
    upd = (muIt - abs(muRec)) + lambda*(wdecMat'*sign(wdecMat*muIt));
    
    diffOp = waveOp_mu(u1Noise, u2Noise, gridSize);
    diffVec = [-D1*u1Noise(2:end-1); -D2*u2Noise(2:end-1)];

    updWithU =  diffOp'*(diffOp*muWithU - diffVec) + lambda*wdecMat'*sign(wdecMat*muWithU);
    
    %upd = (muIt - abs(muRec)) + lambda*median_mult(wdecMat,muIt);
    
    %full([sign(median_mult(wdecMat,muIt)) sign(wdecMat'*sign(wdecMat*muIt))])
    
    muIt = muIt - alpha*upd;
    muWithU = muWithU - alpha*updWithU;
    
    %updThresh = (muThresh - abs(muRec));
    
    % muThresh = wlet_denoise(muThresh + alpha*updThresh, level, 'db5', 0,0.05,0);
    
    
end

plot(xVec, muVec, 'b', xVec, muRec, 'r', xVec, muIt, 'g', xVec, muWithU, 'g--', 'LineWidth',1);

