function [x, cost] = ogs3(y, K, lam, pen, rho, Nit)

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

K1 = K(1);
K2 = K(2);
K3 = K(3);

a_max = 1/(lam*K1*K2*K3);
a = rho * a_max;

switch pen
    case 'abs'
        phi = @(x) abs(x);
        wfun = @(x) abs(x);
        a = 0;
    case 'rat'
        phi = @(x) abs(x)./(1+a*abs(x)/2);
        wfun = @(x) abs(x) .* (1 + a*abs(x)/2).^2;
    case 'log'
        phi = @(x) 1/a * log(1 + a*abs(x));
        wfun = @(x) abs(x) .* (1 + a*abs(x));
    case 'atan'
        phi = @(x) 2/(a*sqrt(3)) *  (atan((1+2*a*abs(x))/sqrt(3)) - pi/6);
        wfun = @(x) abs(x) .* (1 + a*abs(x) + a^2.*abs(x).^2);
    otherwise
        disp('penalty must be abs, log, atan, or rat')
        x = []; cost = [];
        return
end


h1 = ones(K1, 1, 1);
h2 = ones(1, K2, 1);
h3 = ones(1, 1, K3);
x = y;
cost = zeros(1, Nit);

for it = 1 : Nit
    r = sqrt( convn(convn(convn(abs(x).^2, h1, 'full'), h2, 'full'), h3, 'full') );
    cost(it) = 0.5 * sum(abs(x(:)-y(:)).^2) + lam * sum(phi(r(:)));
    v = 1 + lam*convn(convn(convn(1./wfun(r), h1, 'valid'), h2, 'valid'), h3, 'valid');
    x = y./v;
end

