function w = udwt(x, J, h0, h1)

% Undecimated Discrete Wavelet Transform
%
% INPUT
%   x  : input signal
%   J  : number of stages
%   h0 : low-pass analysis filter
%   h1 : high-pass analysis filter
%
% OUTPUT
%   w  : cell array of wavelet coefficients
%
% EXAMPLE 
%  [h0, h1, g0, g1] = daubf(3);
%  N = 20;
%  x = rand(1,N);
%  J = 3;
%  w = udwt(x, J, h0, h1);
%  y = iudwt(w,  J, g0, g1);
%  err = x - y(1:N);
%  max(abs(err))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

R = sqrt(2);
h0 = h0/R;
if size(h0, 1) == 1
    h0 = permute(h0, [2 1]);
end
if size(h1, 1) == 1
    h1 = permute(h1, [2 1]);
end
h1 = h1/R;

N0 = length(h0);
N1 = length(h1);

isrow = 0;
if size(x,1) == 1
    x = permute(x, [2 1]);
    isrow = 1;
end

w = cell(1,J);
for j = 1:J

    L = length(x);
    M = 2^(j-1);
    lo = zeros(L+M*(N0-1),1);
    hi = zeros(L+M*(N1-1),1);

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





