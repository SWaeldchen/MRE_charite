function [im_filt, mask_full] = lowpass_butter_2d(order, cut, im)

sz = size(im);
midpt = round(sz/2);
[x y] = meshgrid( (1:midpt(2)) / midpt(2), (1:midpt(1)) / midpt(1) ); % normalised coordinates
norm_locs = sqrt(x.^2 + y.^2) / sqrt(2);
mask_quarter = 1 ./ ( 1 + (norm_locs / cut).^(2*order) );
mask_full = [fliplr(flipud(mask_quarter)), flipud(mask_quarter); fliplr(mask_quarter), mask_quarter];
im_fft = fftshift(fft2(im));
im_fft_filt = im_fft .* mask_full;
im_filt = ifft2(ifftshift(im_fft_filt));


