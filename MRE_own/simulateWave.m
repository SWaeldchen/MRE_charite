clear;

gridSize = 2000;
deltaX = 1/gridSize;
rho     = 1;
omega1   = 400;
omega2   = 200;

D1 = deltaX^2*rho*omega1^2;
D2 = deltaX^2*rho*omega2^2;



xVec = (1:gridSize)'/gridSize;

muVec = mu_func(xVec)';
 
u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

snr = 10;

u1 = u1 + randn(size(u1))/200;
u2 = u2 + randn(size(u2))/200;

v1 = wlet_denoise(u1, 10, 'db8', 0.025);
v2 = wlet_denoise(u2, 10, 'db8', 0.025);

% 
% 
recMu = invert_for_mu(D1, D2, u1, u2, gridSize);
recMv = invert_for_mu(D1, D2, v1, v2, gridSize);

recMv = wlet_denoise(recMv, 5, 'db1', 3);

% a = cwt(u1,gridSize);
% SC = wscalogram('image',cwt(u1,gridSize));

rel_dist(muVec, recMv)/rel_dist(muVec, recMu)

% plot(xVec, u1, 'r', xVec, u2, 'r', xVec, muVec, 'b', xVec, recMv, '--b');

plot(xVec, muVec+3, 'b', xVec, recMu+3, 'r', xVec, muVec, 'b', xVec, recMv, '--r');