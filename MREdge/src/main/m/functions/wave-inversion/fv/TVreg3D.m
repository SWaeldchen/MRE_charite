function [x,J] = TVreg3D(y,lambda,epsilon)
%
% x = TVreg3D(y,lambda,epsilon) 
%
% Solves
%    x = argmin sum_i |x - y_i|^2 + lambda*TV(x)
% 
% where we use the approximation
%    TV(y) = sqrt(y^2 + epsilon).
%
% Note: We assume that dim(y) = [nx,ny,nz,ni] while
% dim(x) = [nx,ny,nz], where 
% [nx,ny,nz] is the grid size and
% ni =  number of independent solutions of x (==> x_1,x_2,...)
%
% By default, epsilon=1.2/min([nx,ny,nz]).
%
% This code uses a Steepest-descent method, and it was inspired by 
% G. Peyre's "numerical tours" site:
% http://www.numerical-tours.com/matlab/
%
% J.Mura (2017)
%

ss = size(y);
if numel(ss)<3
    error('This method requires a 3D input.');
elseif numel(ss)==3
    disp('Warning: We have detected only one image');
end



%% Optimization parameters
if nargin<2
    lambda = 0.04; %0.3/5;
    fprintf(' * By default we take lambda=%g\n',lambda);
end
if nargin<3
    epsilon=0.9/min(ss(1:3));
    fprintf(' * By default we take epsilon=%g\n',epsilon);
end


%% Operators
% gradient of the image
grad = @(x)cat(4, x-x([end 1:end-1],:,:), x-x(:,[end 1:end-1],:), x-x(:,:,[end 1:end-1]));

% divergence
div = @(x)x([2:end 1],:,:,1)-x(:,:,:,1) + x(:,[2:end 1],:,2)-x(:,:,:,2) + x(:,:,[2:end 1],3)-x(:,:,:,3);

% TV norm
NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.*conj(u),4));
TV = @(x,epsilon)sum(sum(sum(NormEps(grad(x),epsilon))));

% Gradient of regularization (TV)
Normalize = @(u,epsilon)u./repmat(NormEps(u,epsilon), [1 1 1 3]);
GradTV = @(x,epsilon)-div( Normalize(grad(x),epsilon) );




%% initialization: Gradient descent
min_tau  = 1e-3;
max_iter = 200;

x = mean(y,4); % initial point

J0  = zeros(max_iter,1);
JTV = zeros(max_iter,1);
Jold = 1e20; % init
x0 = x(2:end-1,2:end-1,2:end-1);
gradJ = 0;
N3 = numel(x);

% rescaling step size
norm_x0 = norm(x0(:));
tau     = norm_x0 * 1.5;
min_tau = norm_x0 * min_tau;
lambda  = lambda * norm_x0;

fprintf(' * scaling step-size and lagrange-multiplier by a factor=%g:\n',norm_x0);
fprintf('     new tau=%g (lower bound=%g),  new lambda=%g\n',tau,min_tau,lambda);


tic;
%% optimization steps
for iter = 1 : max_iter 
    gradJ0 = gradJ; % keep old value
    gradJ  = 0;     % reinit
    for f=1:size(y,4)
        z = x0 - squeeze(y(2:end-1,2:end-1,2:end-1,f));
        J0(iter) = J0(iter) + 1/2*sum(z(:).*conj(z(:))) / N3^2;
        gradJ = gradJ + z;
    end
    gradJ = gradJ + lambda*GradTV(x0,epsilon);
    JTV(iter) = TV(x0,epsilon) / N3;
    
    % new objective function
    Jnew = J0(iter) + lambda*JTV(iter);
    
    % normalization
    norm_gradJ = norm(gradJ(:))^2;
    gradJ = gradJ / norm_gradJ ;

    % update solution: using steepest-descent
    x1 = x0 - tau*gradJ;
       
    % new messages
    fprintf('iter=%d, Jnew=%g, Jold=%g, step=%g',iter,Jnew,Jold,tau);
    
    % figures
    figure(1); clf;
    subplot(1,2,1);
    slice(real(x1),ceil(ss(1)/2),ceil(ss(2)/2),ceil(ss(3)/4));
    title('real part'); shading interp; axis equal; colorbar;
    subplot(1,2,2);
    slice(imag(x1),ceil(ss(1)/2),ceil(ss(2)/2),ceil(ss(3)/4));
    title('imaginary part'); shading interp; axis equal; colorbar;
    
    figure(2); clf;
    subplot(1,3,1);
    plot(J0(1:iter),'-o'); title('J_0 = 1/2 \Sigma_i ||x-y_i||^2_2'); ylabel('iterations');
    subplot(1,3,2);
    plot(JTV(1:iter),'-o'); title('TV(x) = ||\nabla x||_1'); ylabel('iterations');
    subplot(1,3,3);
    plot(J0(1:iter)+JTV(1:iter),'-o'); title('J_0(x) + \tau TV(x)'); ylabel('iterations');
    
    figure(3); clf;
    subplot(1,2,1);
    surf(squeeze(abs(x1(:,:,ceil(end/2))))); shading interp;
    view(0,90);
    colorbar; title('solution (new)');
    subplot(1,2,2);
    surf(squeeze(abs(gradJ(:,:,ceil(end/2))))); shading interp;
    view(0,90);
    colorbar;title('gradient');
    
    
    % controlling the descent
    remount = 1 + 20/iter^2; % allows a 'little' remount
    if (Jnew > remount*Jold)
        tau = 0.5*tau;
        gradJ = gradJ0; % reuse old gradient
        fprintf(' [Rejected]\n');
        
        if tau<min_tau
            disp('min tol achieved');
            break;
        end
    else
        % accept
        tau = 1.5*tau; % we trust in this gradient!
        Jold = Jnew;
        fprintf('\n');
        x0 = x1;
    end
    
    drawnow limitrate;
    %pause;
    
end 
t_gd = toc;
fprintf(' elapsed time: %g\n',t_gd);

% reconstitution of x in interior nodes
x(2:end-1,2:end-1,2:end-1) = x1;

% final objective function
J = J0(1:iter) + tau*JTV(1:iter);

return;

