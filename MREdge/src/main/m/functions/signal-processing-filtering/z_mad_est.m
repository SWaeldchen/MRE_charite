function [mad, mad_norm, mad_circ] = z_mad_est(x)

% estimates z noise levels of an MRE complex wave field, real or imag
% separately

if (~isreal(x))
    display('for real data only');
    mad = [];
    mad_norm = [];
    mad_circ = [];
    return;
end

mid_circ = middle_circle(x);
med_mid_circ = median(abs(mid_circ), 3);
ad_circ = abs(mid_circ - repmat(med_mid_circ, [1 1 size(mid_circ,3)]));
mad_circ = median(ad_circ, 3);
mad = median(mad_circ(~isnan(mad_circ)));
mad_norm = mad / median(med_mid_circ(~isnan(med_mid_circ)));
