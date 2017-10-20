function y = idwt3D_u(w, J, sf)

% Inverse 3-D Discrete Wavelet Transform
%
% USAGE:
%   y = idwt3D(w, J, sf)
% INPUT:
%   w - wavelet coefficient
%   J  - number of stages
%   sf - synthesis filters
% OUTPUT:
%   y - output array
% See: dwt3D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

y = w{J+1};
for j = J:-1:1
   y = sfb3D_u(y, w{j}, j, sf, sf, sf);
end

