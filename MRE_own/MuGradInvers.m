% Buildup phase

%% Set parameters

%%% All physical parameters

rho     = 1;
omega1   = 100;
omega2   = 120;

%%% All numerical parameters

resol = 200;
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

snr = 20;
u1Noise = u1 + max(u1)*randn(size(u1))/snr;
u2Noise = u2 + max(u2)*randn(size(u2))/snr;

plot(xVec, u1Noise, xVec, u1);