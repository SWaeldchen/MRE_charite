function [mag, phi] = finish_from_hodge(U_denoise, freqvec, spacing, hodge_code, hodge_iter)

U = U_denoise;
U = hodge_decomp(U_denoise, hodge_code, hodge_iter);
twoD = 0;

[magNum, magDenom, phiNum, phiDenom] = invert(U, freqvec, spacing, 0);
mag = magNum ./ magDenom;
phi = acos(-phiNum ./ phiDenom);

mag(isnan(mag)) = 0;
phi(isnan(phi)) = 0;
