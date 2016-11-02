function [mag, phi] = helmholtz_inversion(U_denoise, freqvec, spacing)

U = U_denoise;
twoD = 0;

% take derivatives and interpolate

[magNum, magDenom, phiNum, phiDenom] = invert(U, freqvec, spacing);
mag = magNum ./ magDenom;
phi = acos(-phiNum ./ phiDenom);

mag(isnan(mag)) = 0;
phi(isnan(phi)) = 0;
