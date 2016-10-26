function [lo, hi] = afb2D_A_u(x, j, h0, h1, d)

% 2D Analysis Filter Bank
% (along one dimension only)
%
% [lo, hi] = afb2D_A(x, af, d);
% INPUT:
%    x - NxM matrix, where min(N,M) > 2*length(filter)
%           (N, M are even)
%    af - analysis filter for the columns
%    af(:, 1) - lowpass filter
%    af(:, 2) - highpass filter
%    d - dimension of filtering (d = 1 or 2)
% OUTPUT:
%     lo, hi - lowpass, highpass subbands
%
% % Example
% x = rand(32,64);
% [af, sf] = farras;
% [lo, hi] = afb2D_A(x, af, 1);
% y = sfb2D_A(lo, hi, sf, 1);
% err = x - y;
% max(max(abs(err)))

if d == 2
   x = x';
end

R = sqrt(2);
h0 = h0/R;
h1 = h1/R;

N0 = length(h0);
N1 = length(h1);

sz = size(x);
L = sz(2);
M = 2^(j-1);
lo = zeros(sz(1),sz(2)+M*(N0-1));
hi = zeros(sz(1),sz(2)+M*(N1-1));

% convolution

% EB - make filtering matrix


for k = 0:N1-1
    hi(:, M*k+(1:L)) = hi(:, M*k+(1:L)) + h1(k+1)*x;
end
for k = 0:N0-1
    lo(:, M*k+(1:L)) = lo(:, M*k+(1:L)) + h0(k+1)*x;
end

if d == 2
   lo = lo';
   hi = hi';
end


