function MAD = get_mad(volume, mask)
if nargin < 2
    mask = ones(size(vec(volume)));
end

vol_mask = volume .* mask;
% kill nan
vol_mask(isnan(vol_mask)) = 0;
% exclude zero
volvec_nonzero = vol_mask(vol_mask ~= 0);
volvec_median = median(real(volvec_nonzero));
MAD = median(abs(volvec_nonzero - volvec_median));