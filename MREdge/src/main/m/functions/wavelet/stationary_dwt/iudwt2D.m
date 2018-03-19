function y = iudwt2D(w, J, g0, g1)

% Inverse Undecimated 2-D Discrete Wavelet Transform
%
% INPUT
%   w : wavelet coefficients
%   J : number of stages
%   sf : synthesis filters
%
% OUTPUT
%   y : output array
%
% See: udwt2D, idwt2D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/

y = w{J+1}; % y is the lowpass
for j = J:-1:1
   y = sfb2D_u(y, w{j}, j, [g0, g1], [g0, g1]);
end

m = numel(g0) - 1;
y = y(1:end-m, 1:end-m);
