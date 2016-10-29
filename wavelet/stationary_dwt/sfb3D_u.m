function y = sfb3D_u(lo, hi, j, sf1, sf2, sf3)

% 3D Synthesis Filter Bank
%
% USAGE:
%   y = sfb3D(lo, hi, sf1, sf2, sf3);
% INPUT:
%   lo, hi - lowpass subbands
%   sfi - synthesis filters for dimension i
% OUPUT:
%   y - output array
% See afb3D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

if nargin < 4
   sf2 = sf1;
   sf3 = sf1;
end

LLL = lo;
LLH = hi{1};
LHL = hi{2};
LHH = hi{3};
HLL = hi{4};
HLH = hi{5};
HHL = hi{6};
HHH = hi{7};

% filter along dimension 3
LL = sfb3D_A_u(LLL, LLH, j, sf3, 3);
LH = sfb3D_A_u(LHL, LHH, j, sf3, 3);
HL = sfb3D_A_u(HLL, HLH, j, sf3, 3);
HH = sfb3D_A_u(HHL, HHH, j, sf3, 3);

% filter along dimension 2
L = sfb3D_A_u(LL, LH, j, sf2, 2);
H = sfb3D_A_u(HL, HH, j, sf2, 2);

% filter along dimension 1
y = sfb3D_A_u(L, H, j, sf1, 1);


% LOCAL FUNCTION

function y = sfb3D_A_u(lo, hi, j, sf, d)

% 3D Synthesis Filter Bank
% (along single dimension only)
%
% y = sfb3D_A(lo, hi, sf, d);
% sf - synthesis filters
% d  - dimension of filtering
% see afb2D_A

R = sqrt(2);
g0 = sf(:, 1) / R;     % lowpass filter
g1 = sf(:, 2) / R;     % highpass filter
N0 = length(g0);
N1 = length(g1);
N = N0 + N1;

% permute dimensions of lo and hi so that dimension d is first.
p = mod(d-1+[0:2], 3) + 1;
lo = permute(lo, p);
hi = permute(hi, p);


sz0 = size(lo);
L0 = sz0(1);
sz1 = size(hi);
L1 = sz1(1);

M = 2^(j-1);

y0 = zeros(L0+M*(N0-1), sz0(2), sz0(3));
y1 = zeros(L1+M*(N1-1), sz1(2), sz1(3));

for k = 0:N0-1
    y0(M*k+(1:L0),:,:) = y0(M*k+(1:L0),:,:) + g0(k+1)*lo;
end

for k = 0:N1-1
    y1(M*k+(1:L1),:,:) = y1(M*k+(1:L1),:,:) + g1(k+1)*hi;
end

% Add signals (make sure they are equal length).
% We assume 'lo' is longer than 'hi' because
% in a wavelet transform the lo/hi split is
% iterated on the 'lo' signal which increases its length.
y = y0(1:size(y1, 1),:,:);
y(1:size(y1,1), 1:size(y1,2), 1:size(y1,3)) = y(1:size(y1,1), 1:size(y1,2), 1:size(y1,3)) + y1;

L = M*(N/2-1);
y = y(L+1:end,:,:);



% permute dimensions of y (inverse permutation)
y = ipermute(y, p);


