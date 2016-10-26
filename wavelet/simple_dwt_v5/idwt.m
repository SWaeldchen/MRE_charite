function y = idwt(w, J, g0, g1)

% INVERSE DISCRETE WAVELET TRANSFORM
% y = idwt(w, J, g0, g1);
% INPUT
%  w : wavelet coefficients
%  J : number of stages
%  g0 : low-pass synthesis filter
%  g1 : high-pass synthesis filter
% OUTPUT
%   y : output signal

N = (length(g0) + length(g1)) / 2;
y = w{J+1};
for j = J:-1:1
    lo = upfirdn(y, g0, 2, 1);
    hi = upfirdn(w{j}, g1, 2, 1);

    % Add signals (first make sure they are equal length)
    % and remove leading zeros
    Nhi = length(hi);
    y = lo(N:Nhi) + hi(N:end);
end