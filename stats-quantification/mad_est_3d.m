function sigma = mad_est_3d(volume, mask)
if nargin < 2
    mask = ones(size(vec(volume)));
end
sz = size(volume);
[h0, h1, g0, g1] = daubf(3);
af = [h0 h1];
w = udwt3D(volume, 1, af);
coeffs = vec(w{1}{7}(6:end, 6:end, 6:end));
% mask
volvec = coeffs .* vec(mask);
% kill nan
volvec(isnan(volvec)) = 0;
% exclude zero
volvec_nonzero = volvec(volvec ~= 0);
volvec_median = median(real(volvec_nonzero));
sigma = median(abs(volvec_nonzero - volvec_median));