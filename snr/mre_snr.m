function [disp_snr, strain_snr, lap_snr] = mre_snr(img, spacing, mask)
if nargin < 2
    mask = true(size(img));
end
disp_snr = donoho_method_snr_multichannel(img, mask);
strain_snr = donoho_method_snr(oss_image(img, spacing), mask);
lap_snr = donoho_method_snr_multichannel( ...
    laplacian_image(img, spacing,3,2), ...
    mask);