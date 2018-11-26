function [ U ] = iterate_for_u_2d( mu, deltaX, deltaY, rhoOm2, gridSizeX, gridSizeY )
%ITERATE FOR_U_2D Summary of this function goes here
%   Detailed explanation goes here

gsX = gridSizeX;
gsY = gridSizeY;


dx_mu = (mu(3:end,:) - mu(1:end-2,:))/(2*deltaX);
dx_mu_dx1 = vec([-dx_mu + mu(2:end-1,:); zeros(2,gsY)])/deltaX;
dx_mu_dx2 = vec([ones(1,gsY); -2*mu(2:end-1,:); ones(1,gsY)]);
dx_mu_dx3 = vec([zeros(2,gsY); dx_mu + mu(2:end-1,:)])/deltaX;

dx_mu_dx = spdiags([vec(dx_mu_dx_(:,:,1)), vec(dx_mu_dx_(:,:,2)), vec(dx_mu_dx_(:,:,3))], [-gsY,0,gsY], gsY*gsX, gsY*gsX);

%%%%% Construct dx_mu_dx %%%

gradKernel = [-1,0,1];
lapKernel = [1,-2,1];

% dx_mu = (mu(3:end,2:end-1) - mu(1:end-2,2:end-1))/(2*deltaX);
% dy_mu = (mu(2:end-1,3:end) - mu(2:end-1,1:end-2))/(2*deltaY);
% core_mu = mu(2:end-1,2:end-1);
% 
% gradXKernel = zeros(3,3,3); gradXKernel(:,2,:) = diag(gradKernel)/(2*deltaX);
% lapXKernel = zeros(3,3,3); lapXKernel(:,2,:) = diag(lapKernel)/deltaX;
% gradYKernel = zeros(3,3,3); gradYKernel(2,:,:) = diag(gradKernel)/(2*deltaY);
% lapYKernel = zeros(3,3,3); lapYKernel(2,:,:) = diag(lapKernel)/deltaY;
% 
% dx_mu_dx_ = convn(dx_mu, gradXKernel) + convn(core_mu, lapXKernel);
% dy_mu_dy_ = convn(dy_mu, gradYKernel) + convn(core_mu, lapYKernel);

%dx_mu = [zeros(2,gsY);dx_mu;zeros(1,gsY)];


% dx_mu_dx = spdiags([vec(dx_mu_dx_(:,:,1)), vec(dx_mu_dx_(:,:,2)), vec(dx_mu_dx_(:,:,3))], [-gsY,0,gsY], gsY*gsX, gsY*gsX);
% dy_mu_dy = spdiags([vec(dy_mu_dy_(:,:,1)), vec(dy_mu_dy_(:,:,2)), vec(dy_mu_dy_(:,:,3))], [-1,0,1],     gsY*gsX, gsY*gsX);

% full(dx_mu_dx)

%%%%% Construct dy_mu_dy %%%

% dy_mu = (mu(:,3:end) - mu(:,1:end-2))/4;
% 
% dy_mu_dy1 = vec([-dy_mu + mu(:,2:end-1), zeros(gsX,2)])/deltaY;
% dy_mu_dy2 = vec([ones(gsX,1), -2*mu(:,2:end-1), ones(gsX,1)])/deltaY;
% dy_mu_dy3 = vec([zeros(gsX,2), dy_mu + mu(:,2:end-1)])/deltaY;
% 
% 
% dy_mu_dy = spdiags([dy_mu_dy1, dy_mu_dy2, dy_mu_dy3], [-1,0,1], gsY*gsX, gsY*gsX);

% full(dy_mu_dy)


waveOp = 2*dx_mu_dx + dy_mu_dy + rhoOm2*speye(gsX*gsY, gsX*gsY);

xBound = zeros(gsX, gsY);
xBound(1,:) = 1;
xBound(end,:) = 1;

yBound = zeros(gsX, gsY);
yBound(:,1) = 1;
yBound(2:end-1,end) = 1;

boundVec = rhoOm2*vec(xBound + yBound);

U = lsqr(waveOp,boundVec,1E-6, 1E6);

U = mat(U, gsX, gsY);

end

