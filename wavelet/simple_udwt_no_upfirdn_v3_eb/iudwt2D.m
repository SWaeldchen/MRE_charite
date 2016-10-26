function y = iudwt2D(w, J, g0, g1)

% Inverse 2-D Discrete Wavelet Transform
%
% USAGE:
%   y = idwt(w, J, sf)
% INPUT:
%   w - wavelet coefficients
%   J  - number of stages
%   sf - synthesis filters
% OUTPUT:
%   y - output array
% See dwt2D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

y = w{J+1}; % y is the lowpass
for j = J:-1:1
   y = sfb2D_u(y, w{j}, j, g0, g1);
end

