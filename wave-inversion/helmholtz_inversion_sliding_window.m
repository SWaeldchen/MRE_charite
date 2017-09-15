function [mag, phi_new, phi_old] = helmholtz_inversion_sliding_window(U_denoise, freqvec, spacing, ndims, ord, iso)

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
% take derivatives
n_invs = numel(freqvec) - 2;
mag = cell(n_invs,1);
phi_new = cell(n_invs,1);
phi_old = cell(n_invs,1);

for n = 1:n_invs
    [magNum, magDenom, phiNum, phiDenom, phiNew] = invert(U(:,:,:,:,n:n+2), freqvec(n:n+2), spacing, ndims, ord, iso);
    mag{n} = magNum ./ magDenom;
    phi_old{n} = acos(-phiNum ./ phiDenom);
    phi_new{n} = angle(-phiNew);
end