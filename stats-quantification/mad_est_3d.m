function sigma = mad_est_3d(volume)

volvec = volume(:);
% kill nan
volvec(isnan(volvec)) = 0;
% exclude zero
volvec_nonzero = volvec(volvec ~= 0);
volvec_median = median(volvec_nonzero);
sigma = median(abs(volvec_nonzero - volvec_median));