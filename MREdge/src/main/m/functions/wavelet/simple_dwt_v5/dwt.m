function w = dwt(x, J, h0, h1)

% DISCRETE WAVELET TRANSFORM
% w = dwt(x, J, h0, h1);
% INPUT
%   x  : input signal
%   J  : number of stages
%   h0 : low-pass analysis filter
%   h1 : high-pass analysis filter
% OUTPUT
%   w  : wavelet coefficients

w = cell(1,J);
for j = 1:J
    w{j} = upfirdn(x, h1, 1, 2);
    x = upfirdn(x, h0, 1, 2);
end
w{J+1} = x;
