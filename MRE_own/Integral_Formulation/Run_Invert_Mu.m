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

k = 100;
lambda = 0;
intLambda = 300;

muRec = invert_for_mu(u1Denoised, u2Denoised, sigma1, sigma2, lambda);
muIntRec = integral_invert_for_mu(u1Noise, u2Noise, sigma1, sigma2, k, intLambda);


plot(xVec, muVec, xVec, cumsum([0;muIntRec]), xVec, muRec)


norm(muVec - muRec)/norm(muVec - cumsum([0;muIntRec]))