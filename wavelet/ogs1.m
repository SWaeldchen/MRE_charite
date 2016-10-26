function [x, cost] = ogs1(y, K, lam, pen, rho, Nit)

% [x, cost] = ogs1(y, K, lam, pen, rho, Nit)
% Overlapping Group Shrinkage/Thresholding (1D)
%
% Input
%   y    : input signal (1D array)
%   lam  : regularization parameter
%   K    : group size
%   pen  : penalty ('abs', 'log', 'atan', 'rat')
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

a_max = 1/(lam*K);
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
        error('penalty must be ''abs'', ''log'', ''atan'', or ''rat''')
end


y = y(:);
h = ones(K, 1);
x = y;
cost = zeros(1, Nit);

for it = 1 : Nit
    r = sqrt( conv(abs(x).^2, h, 'full') );
    cost(it) = 0.5 * sum(abs(x-y).^2) + lam * sum(phi(r));
    v = 1 + lam*conv( 1./( wfun(r) ), h, 'valid');
    x = y./v;
end
end
