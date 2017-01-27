function [mag, phi] = mdev_invert(U, freqvec, spacing, twoD)



[magNum, magDenom, phiNum, phiDenom] = invert(U, freqvec, spacing, twoD);
mag = magNum ./ magDenom;
phi = acos(-phiNum ./ phiDenom);
mag(isnan(mag)) = 0;
phi(isnan(phi)) = 0;