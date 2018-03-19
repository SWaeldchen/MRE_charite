function [cut_corr, mean_core_diff] = test_frequency_cuts(sl, cut, display)
if (nargin < 3) display = 0; end;
sl(isnan(sl)) = 0;
sl_ft = log(normalizeImage(abs(fftshift(fft2(sl))))) ./ log(10);
sl_ft2 = fftshift(fft2(sl));
sl_ft2(sl_ft < cut) = 0;
sl_cut = ifft2(ifftshift(sl_ft2));
if display > 0
    openImage(sl_cut, MIJ, 'sl_cut');
    openImage(sl - sl_cut, MIJ, 'diff');
end
corr_diff = abs(sl-sl_cut);
cut_corr = corr(sl_cut(:), corr_diff(:));
mean_core_diff = mean(corr_diff(:));