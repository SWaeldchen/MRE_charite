function [mag, phi_old] = helmholtz_inversion_guided(U_denoise, guidance_mask, freqvec, spacing)

U = U_denoise;
if nargin < 6
    iso = 1;
    if nargin < 5
        ord = 4;
        if nargin < 4
            ndims = 3;
        end
    end
end
% take derivatives and interpolate

[magNum, magDenom, phiNum, phiDenom] = invert_guided(U, guidance_mask, freqvec, spacing);
mag = magNum ./ magDenom;
mag(isinf(mag)) = 0;
phi_old = acos(-phiNum ./ phiDenom);
%phi_new = angle(-phiNew);
