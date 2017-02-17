function [lo, hi] = afb2D_u(x, j, af1, af2)

% Undecimated 2D Analysis Filter Bank
%
% USAGE:
%   [lo, hi] = afb2D_u(x, af1, af2);
% INPUT:
%   x - N by M matrix
%       1) M, N are both even
%       2) M >= 2*length(af1)
%       3) N >= 2*length(af2)
%   af1 - analysis filters for columns
%   af2 - analysis filters for rows
% OUTPUT:
%    lo - lowpass subband
%    hi{1} - 'lohi' subband
%    hi{2} - 'hilo' subband
%    hi{3} - 'hihi' subband
% EXAMPLE:
%   x = rand(32,64);
%   [af, sf] = farras;
%   [lo, hi] = afb2D(x, af, af);
%   y = sfb2D(lo, hi, sf, sf);
%   err = x - y;
%   max(max(abs(err)))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

% filter along columns
[L, H] = afb2D_A_u(x, j, af1, 1);

% filter along rows
[lo,    hi{1}] = afb2D_A_u(L, j, af2, 2);
[hi{2}, hi{3}] = afb2D_A_u(H, j, af2, 2);

end

% LOCAL FUNCTION

function [lo, hi] = afb2D_A_u(x, j, af, d)

if d == 2
   x = x';
end

R = sqrt(2);
h0 = af(:,1)/R;
h1 = af(:,2)/R;

N0 = length(h0);
N1 = length(h1);

sz = size(x);
L = sz(1);
M = 2^(j-1);
lo = zeros(sz(1)+M*(N0-1),sz(2));
hi = zeros(sz(1)+M*(N1-1),sz(2));

for k = 0:N1-1
    hi(M*k+(1:L),:) = hi(M*k+(1:L),:) + h1(k+1)*x;
end
for k = 0:N0-1
    lo(M*k+(1:L),:) = lo(M*k+(1:L),:) + h0(k+1)*x;
end

if d == 2
   lo = lo';
   hi = hi';
end

end
