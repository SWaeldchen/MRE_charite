function sigma = mredge_est_mad(volume, mask, normalize)
if nargin < 3
	normalize = 1;
end
volvec = volume(:);
maskvec = mask(:);
% kill nan
volvec(isnan(volvec)) = 0;
% exclude zero masked
volvec_nonzero = volvec(mask ~= 0);
if normalize == 1
	volvec_nonzero = normalizeImage(volvec_nonzero);
end
volvec_median = median(volvec_nonzero);
sigma = median(abs(volvec_nonzero - volvec_median));
