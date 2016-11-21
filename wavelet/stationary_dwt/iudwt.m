function y = iudwt(w, J, g0, g1)

% y = iudwt(w, J, g0, g1)
%
% Inverse undecimated discrete wavelet transform
% INPUT
%   w : wavelet coefficients
%   J : number of stages
%   g0 : low-pass synthesis filter
%   g1 : high-pass synthesis filter
% OUTPUT
%   y : output signal


R = sqrt(2);
g0 = g0/R;
g1 = g1/R;

N0 = length(g0);
N1 = length(g1);
N = N0 + N1;

y = w{J+1};
for j = J:-1:1
    M = 2^(j-1);

    lo = y;
    hi = w{j};

    L0 = length(lo);
    L1 = length(hi);

    y0 = zeros(L0+M*(N0-1),1);
    y1 = zeros(L1+M*(N1-1),1);

    for k = 0:N0-1
        y0(M*k+(1:L0)) = y0(M*k+(1:L0)) + g0(k+1)*lo;
    end

    for k = 0:N1-1
        y1(M*k+(1:L1)) = y1(M*k+(1:L1)) + g1(k+1)*hi;
    end

    % Add signals (make sure they are equal length).
    % We assume 'lo' is longer than 'hi' because
    % in a wavelet transform the lo/hi split is
    % iterated on the 'lo' signal which increases its length.
    y = y0(1:length(y1)) + y1;

    L = M*(N/2-1);
    y = y(L+1:end);
end
