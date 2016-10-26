function w = udwt2(x, J, h0, h1);

function w = udwt(x, J, h0, h1)

% Undecimated Discrete Wavelet Transform 2D
%
% INPUT
%   x  : input signal
%   J  : number of stages
%   h0 : low-pass analysis filter
%   h1 : high-pass analysis filter
% OUTPUT
%   w  : wavelet coefficients
%

R = sqrt(2);
h0 = h0/R;
h1 = h1/R;

N0 = length(h0);
N1 = length(h1);

w = cell(1,J);
for j = 1:J

    L = length(x);
    M = 2^(j-1);
    lo = zeros(1,L+M*(N0-1));
    hi = zeros(1,L+M*(N1-1));

    % convolution:
    for k = 0:N1-1
        hi(M*k+(1:L)) = hi(M*k+(1:L)) + h1(k+1)*x;
    end
    for k = 0:N0-1
        lo(M*k+(1:L)) = lo(M*k+(1:L)) + h0(k+1)*x;
    end

    w{j} = hi;
    x = lo;
end
w{J+1} = x;





