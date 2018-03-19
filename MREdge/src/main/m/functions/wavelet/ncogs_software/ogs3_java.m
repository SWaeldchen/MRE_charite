function [x, cost] = ogs3_java(y, K, lam, pen, rho, Nit, OGSI)

% [x, cost] = ogs3(y, K, lam, pen, rho, Nit)
% Overlapping Group Shrinkage/Thresholding (3D)
%
% Input
%   y    : observed signal (2D array)
%   lam  : regularization parameter
%   K    : group size K = [K1 K2 K3]
%   pen  : 'abs', 'log', 'atan' or 'rat'
%   rho  : normalized non-convexity parameter, 0 <= rho <= 1
%   Nit  : number of iterations
%
% Output
%   x    : output signal
%   cost : cost function history
%
% Note: for the L1 penalty ('abs'), 'rho' must be 0.

% Po-Yu Chen and Ivan Selesnick
% NYU-Poly, 2013

% Perform some error checking
if strcmp(pen, 'abs')
    if rho ~= 0
        error('Error: need rho = 0 for abs penalty')
    end
end
if rho == 0
    pen = 'abs';
elseif (rho < 0) || (rho > 1)
    error('Error: need 0 <= rho <= 1.')
end

% Add java-based convolution method


K1 = K(1);
K2 = K(2);
K3 = K(3);

a_max = 1/(lam*K1*K2*K3);
a = rho * a_max;
h1 = ones(K1, 1, 1);
h2 = ones(1, K2, 1);
h3 = ones(1, 1, K3);
x = y;
x2 = x;
cost = zeros(1, Nit);


x = javaMethod('iterate', OGSI, Nit, h1, h2, h3, real(x2), imag(x2), real(y), imag(y), lam, a, 0);
x = x(:,:,:,1) + 1i*x(:,:,:,2);
%assignin('base', 'v2', x);
%display('done');

