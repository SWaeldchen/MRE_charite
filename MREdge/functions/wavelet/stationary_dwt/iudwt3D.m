function y = iudwt3D(w, J, g0, g1)

% Inverse Undecimated 3-D Discrete Wavelet Transform
%
% INPUT
%   w : wavelet coefficient
%   J : number of stages
%   sf : synthesis filters
%
% OUTPUT:
%   y : output array
%
% See: udwt3D, idwt3D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

if nargin == 3
    sf = g0;
else
    sf = [g0 g1];
end

y = w{J+1};
for j = J:-1:1
   y = sfb3D_u(y, w{j}, j, sf, sf, sf);
end

m = numel(g0) - 1;
y = y(1:end-m, 1:end-m, 1:end-m);

