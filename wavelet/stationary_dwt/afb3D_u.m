function [lo, hi] = afb3D_u(x, j, af1, af2, af3)

% Undecimated 3D Analysis Filter Bank
%
% USAGE:
%    [lo, hi] = afb3D(x, af1, af2, af3);
% INPUT:
%    x - N1 by N2 by N3 array matrix, where
%        1) N1, N2, N3 all even
%        2) N1 >= 2*length(af1)
%        3) N2 >= 2*length(af2)
%        4) N3 >= 2*length(af3)
%    afi - analysis filters for dimension i
%       afi(:, 1) - lowpass filter
%       afi(:, 2) - highpass filter
% OUTPUT:
%    lo - lowpass subband
%    hi{d}, d = 1..7 - highpass subbands
% EXAMPLE:
%    x = rand(32,64,16);
%    [af, sf] = farras;
%    [lo, hi] = afb3D(x, af, af, af);
%    y = sfb3D(lo, hi, sf, sf, sf);
%    err = x - y;
%    max(max(max(abs(err))))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

if nargin < 3
   af2 = af1;
   af3 = af1;
end

% filter along dimension 1
[L, H] = afb3D_A_u(x, j, af1, 1);

% filter along dimension 2
[LL, LH] = afb3D_A_u(L, j, af2, 2);
[HL, HH] = afb3D_A_u(H, j, af2, 2);

% filter along dimension 3
[LLL, LLH] = afb3D_A_u(LL, j, af3, 3);
[LHL, LHH] = afb3D_A_u(LH, j, af3, 3);
[HLL, HLH] = afb3D_A_u(HL, j, af3, 3);
[HHL, HHH] = afb3D_A_u(HH, j, af3, 3);

lo    = LLL;
hi{1} = LLH;
hi{2} = LHL;
hi{3} = LHH;
hi{4} = HLL;
hi{5} = HLH;
hi{6} = HHL;
hi{7} = HHH;

end

% LOCAL FUNCTION

function [lo, hi] = afb3D_A_u(x, j, af, d)

R = sqrt(2);
h0 = af(:, 1) / R;     % lowpass filter
h1 = af(:, 2) / R;     % highpass filter
N0 = length(h0);
N1 = length(h1);
% permute dimensions of x so that dimension d is first.
p = mod(d-1+[0:2], 3) + 1; %#ok<NBRAK>
x = permute(x, p);

% filter along dimension 1

sz = size(x);
L = sz(1);
M = 2^(j-1);
lo = zeros(sz(1)+M*(N0-1),sz(2),sz(3));
hi = zeros(sz(1)+M*(N1-1),sz(2),sz(3));

for k = 0:N1-1
    hi(M*k+(1:L),:,:) = hi(M*k+(1:L),:,:) + h1(k+1)*x;
end
for k = 0:N0-1
    lo(M*k+(1:L),:,:) = lo(M*k+(1:L),:,:) + h0(k+1)*x;
end

% permute dimensions of x (inverse permutation)
lo = ipermute(lo, p);
hi = ipermute(hi, p);

end
