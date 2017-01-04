function [mag, phi] = helmholtz_inversion(U_denoise, freqvec, spacing, twoD)

U = U_denoise;
if nargin < 4
    twoD = 0;
end
% take derivatives and interpolate

[magNum, magDenom, phiNum, phiDenom] = invert(U, freqvec, spacing, twoD);
mag = magNum ./ magDenom;
phi = acos(-phiNum ./ phiDenom);

mag(isnan(mag)) = 0;
phi(isnan(phi)) = 0;
