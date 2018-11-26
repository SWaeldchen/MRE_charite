clear;

rho     = 1;
omega1   = 3;
omega2   = 3;

resolX = 20;
resolY = 20;

gridSizeX = resolX*max(omega1, omega2)
gridSizeY = resolY*max(omega1, omega2)

deltaX = 1/gridSizeX;
deltaY = 1/gridSizeY;
xVec = (1:gridSizeX)'/gridSizeX;
yVec = (1:gridSizeY)'/gridSizeY;

muGrid = mu_func_2D(xVec, yVec);

D1X = deltaX^2*rho*omega1^2;
D1Y = deltaY^2*rho*omega1^2;

D2X = deltaX^2*rho*omega2^2;
D2Y = deltaY^2*rho*omega2^2;

U = iterate_for_u_2d(muGrid, D1X, D1Y, rho*omega1^2, gridSizeX, gridSizeY);

%plot(yVec, U(1,:))

contourf(U)

% 
%  
% u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
% u2 = invert_for_u(muVec, D2, 1, 1, gridSize);
% 
% snr = 2;
% 
% u1Noise = u1 + max(u1)*randn(size(u1))/snr;
% u2Noise = u2 + max(u2)*randn(size(u2))/snr;
% 
% level = ceil(log2(gridSize))
% 
% u1Denoised = wlet_denoise(u1Noise, level, 'db10', 0., 0, 6);
% u2Denoised = wlet_denoise(u2Noise, level, 'db10', 0, 0, 6);
% 
% 
% % u1Den = two_stage_denoise(u1Noise, gridSize);
% % u2Den = two_stage_denoise(u2Noise, gridSize);
% 
% % plot(xVec, u1, 'b', xVec, u1Denoised, 'r', xVec, u1Den, 'g', ...
% %     xVec(2:end), 20*diff(u1)-5, 'b', xVec(2:end), 20*diff(u1Denoised)-5, 'r', xVec(2:end), 20*diff(u1Den)-5, 'g', ...
% %     xVec(3:end), 200*diff(diff(u1))-10, 'b', xVec(3:end), 200*diff(diff(u1Denoised))-10, 'r', xVec(3:end), 200*diff(diff(u1Den))-10, 'g');
% % return
% 
% %%%%%%%%%%%%%
% 
% 
% muRec = invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize);
% muRec2 = iterate_mu(u1Denoised, u2Denoised, D1, D2, gridSize); %invert_for_mu(D1, D2, u1Den, u2Den, gridSize);
% 
% muRec = wlet_denoise(muRec, level, 'db1', 0.98, 0, 6);
% % muRec2 = wlet_denoise(muRec2, level, 'db1', 0.97, 0, 0);
% 
% % norm(muVec-muRec2,1)/norm(muVec-muRec,1)
% % max(abs(muVec-muRec2))/max(abs(muVec-muRec))
% 
% % u1New = iterate_for_u(muRec2, D1, u1Noise, u1Denoised, gridSize);
% % u2New = iterate_for_u(muRec2, D2, u2Noise, u2Denoised, gridSize);
% % 
% %muRec = iterate_mu(u1New, u2New, D1, D2, gridSize);
% %muRec = wlet_denoise(muRec, level, 'db1', 0.98, 0, 6);
% 
% 
% plot(xVec, muVec, 'b', xVec, muRec, 'r', xVec, muRec2, 'g')
