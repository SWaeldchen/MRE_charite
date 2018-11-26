%% Set parameters

%%% All physical parameters

rho     = 1;
omega1   = 20;
omega2   = 40;

%%% All numerical parameters

resol = 20; %20
gridSize = resol*max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;
level = ceil(log2(gridSize));

%%% Physical and numerical values

sigma1 = deltaX^2*rho*omega1^2;
sigma2= deltaX^2*rho*omega2^2;
muVec = mu_func(xVec)'; %+ 0.01*randn(size(xVec));
%muVec = gen_sparse_mu(gridSize, 10, 'db5');

%% Calculating the displacement

u1 = invert_for_u(muVec, sigma1, [1, 1]);
u2 = invert_for_u(muVec, sigma2, [1, 1]);

% D_u = uOp_for_mu(u1);
% return
% 

%% Add the Noise

snr = 10;

u1Noise = u1 + abs(hilbert(u1)).*randn(size(u1))/snr;
u2Noise = u2 + abs(hilbert(u2)).*randn(size(u2))/snr;

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

itSteps = 1;

muRecMat = zeros(gridSize, itSteps);

muWeird = wlet_denoise(muVec, 10, 'db7', 0, 0.01, 0);

muRec = muVec;%ones(size(muVec));

b = zeros(gridSize,1);
b(1) = 1;
b(end) = 1;

for step = 1:itSteps
    
    M1 = waveOp_for_u(muRec, sigma1);
    %M1 = full(inv(M1'*M1));
    M1 = M1'*M1;
    M1 = M1/norm(full(M1));
    nnn = norm(u1 - M1*b)^2  
    
    M2 = waveOp_for_u(muRec, sigma2);
    M2 = M2'*M2;
    %M2 = full(inv(M2'*M2));
    M2 = M2/norm(full(M2));

    lambda = 8000;
    
%     k = 100;
%     M1 = moving_avg_mat(gridSize-k +1, k, 0)*moving_avg_mat(gridSize, k, 0); %(M1'*M1);
%     M1 = M1'*M1;
%     M2 = M1;
    
    muRec = fast_invert_for_mu(u1Noise, u2Noise, sigma1, sigma2, M1, M2, lambda);
    
    muRecMat(:, step) = muRec;
    
    step, norm(muRec - muVec)
    
end

plot(xVec, muVec, 'r*', xVec, muRecMat);