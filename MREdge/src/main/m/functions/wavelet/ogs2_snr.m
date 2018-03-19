function [x, cost] = ogs2_snr(y, K1, K2, snr, pen, rho, Nit)

default_thresh = max(abs(y(:))) / 5;
%display(default_thresh)

% [x, cost] = ogs2(y, K1, K2, lam, pen, rho, Nit)
% Overlapping Group Shrinkage/Thresholding (2D)
%
% Input
%   y      : observed signal (2D array)
%   lam    : regularization parameter
%   K1, K2 : group size
%   pen    : 'abs', 'log', 'atan' or 'rat'
%   rho  : normalized non-convexity parameter, 0 <= rho <= 1
%   Nit    : number of iterations
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
snr_weight = (1 - snr)*default_thresh;
a_max = 1./(snr_weight*K1*K2);
a = rho .* a_max;

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
        phi = @(x,a) 2./(a*sqrt(3)) *  (atan((1+2*a*abs(x))/sqrt(3)) - pi/6);
        wfun = @(x,a) abs(x) .* (1 + a*abs(x) + a^2.*abs(x).^2);
    otherwise
        disp('penalty must be abs, log, atan, or rat')
        x = []; cost = [];
        return
end


h1 = ones(K1, 1);
h2 = ones(K2, 1);
x = y;
cost = zeros(1, Nit);

for it = 1 : Nit
    r = sqrt( conv2(h1, h2, abs(x).^2, 'full') );
    a_temp = ones(size(r));
    a_temp(2:end-1,2:end-1) = a;
    snr_temp = ones(size(r));
    snr_temp(2:end-1,2:end-1) = a;
    
    cost(it) = 0.5 * sum(sum(abs(x-y).^2)) + sum(sum(snr_temp.*phi(r,a_temp)));
    v = 1 + snr_weight.*conv2(h1, h2, 1./wfun(r,a_temp), 'valid');
    x = y./v;
end
