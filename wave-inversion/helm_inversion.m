function absg = helmholtz_inversion(U_denoise, freqvec, spacing, ndims, ord, iso)

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

[magNum, magDenom, phiNum, phiDenom] = invert(U, freqvec, spacing, ndims, ord, iso);
mag = magNum ./ magDenom;
phi_old = acos(-phiNum ./ phiDenom);
%phi_new = angle(-phiNew);
