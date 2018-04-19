function w = udwt3D(x, J, h0, h1)

% Undecimated 3-D Discrete Wavelet Transform
%
% INPUT
%   x : N1 by N2 by N3 matrix
%       1) Ni all even
%       2) min(Ni) >= 2^(J-1)*length(af)
%   J : number of stages
%   af : analysis filters
%
% OUTPUT
%   w : cell array of wavelet coefficients
%
% EXAMPLE
%   [af, sf] = farras;
%   x = rand(128,64,64);
%   J = 3;
%   w = udwt3D(x,J,af);
%   y = iudwt3D(w,J,sf);
%   err = x-y; 
%   max(max(max(abs(err))))
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

if nargin == 3
    af = h0;
else
    af = [h0 h1];
end

for j = 1:J
    [x w{j}] = afb3D_u(x, j, af, af, af);
end
w{J+1} = x;

