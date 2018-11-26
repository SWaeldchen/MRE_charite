function [ mu_gradX ] = invert_for_u_2d(mu, deltaX, deltaY, gridSizeX, gridSizeY)
%INVERT_FOR_U_2D Summary of this function goes here
%   Detailed explanation goes here


%gradKernel = [0.5; 0; -0.5];
gradKernel = [-1; 1];

xGradKernel = gradKernel/(deltaX);
yGradKernel = gradKernel'/(deltaY);

xGradMatrix = spdiags(ones(gridSizeX,1)*gradKernel', [0,1], gridSizeX-1, gridSizeX);
yGradMatrix = spdiags(ones(gridSizeY,1)*gradKernel', [0,-1], gridSizeY-1, gridSizeY);

full(xGradMatrix)

iterate_for_u_2d(



% %calculate gradients of mu
% mu_gradX = convn(mu, xGradKernel, 'valid')
% mu_gradY = convn(mu, yGradKernel, 'valid')
% 
% 
% iterSteps = 1;
% 
% startU = ones(gridSizeX, gridSizeY);
% startV = ones(gridSizeX, gridSizeY);
% 
% 
% for step = 1:iterSteps
%    
%     muDxU = mu.*(xGradMatrix*uIter);
%     muDyU = mu.*(uIter*yGradMatrix);
%     muDxV = mu.*(xGradMatrix*vIter);
%     muDyV = mu.*(vIter*yGradMatrix);
%     
%     
%     deltau = 
%     
%     
% end
% 
% 
% end

