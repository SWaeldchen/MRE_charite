function sigma = mad_est_3d(volume, mask)
if nargin < 2
    mask = ones(size(vec(volume)));
end
sz = size(volume);
[h0, h1, g0, g1] = daubf(3);
af = [h0 h1];
w = dwt3D_u(volume, 1, af);
coef_cat = cell2cat(w{1});
coef_cat = reshape(coef_cat, [size(coef_cat, 1), size(coef_cat, 2), size(coef_cat, 3)/7, 7]);
coef_cat = vec(simplecrop(coef_cat, [sz(1) sz(2) sz(3) 7]));
mask_cat = vec(repmat(mask, [1 1 1 7]));
% mask
volvec = coef_cat .* mask_cat;
% kill nan
volvec(isnan(volvec)) = 0;
% exclude zero
volvec_nonzero = volvec(volvec ~= 0);
volvec_median = median(real(volvec_nonzero));
sigma = median(abs(volvec_nonzero - volvec_median));