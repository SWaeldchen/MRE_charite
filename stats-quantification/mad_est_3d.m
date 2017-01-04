function sigma = mad_est_3d(volume, mask)
if nargin < 2
    mask = ones(size(vec(volume)));
end
volvec = volume(:);
% mask
volvec = volvec .* vec(mask);
% kill nan
volvec(isnan(volvec)) = 0;
% exclude zero
volvec_nonzero = volvec(volvec ~= 0);
volvec_median = median(real(volvec_nonzero));
sigma = median(abs(volvec_nonzero - volvec_median));