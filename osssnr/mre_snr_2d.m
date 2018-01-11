function [disp_snr, strain_snr, lap_snr] = mre_snr_2d(img, spacing, mask)
if nargin < 2
    mask = true(size(img));
end
disp_snr = donoho_method_snr_multichannel(img, mask);
strain_snr = donoho_method_snr(oss_image_2d(img, spacing), mask);
lap_snr = donoho_method_snr_multichannel( ...
    laplacian_image(img, spacing,2,2), ...
    mask);