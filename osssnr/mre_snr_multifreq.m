function [disp_snr, strain_snr, lap_snr] = mre_snr_multifreq(img, spacing, mask)
sz = size(img);
[img_resh, n_freq] = resh(img, 5);
disp_snr = zeros(n_freq, 1);
strain_snr = zeros(n_freq, 1);
lap_snr = zeros(n_freq, 1);
if nargin < 2
    mask = true(sz(1:3));
end
for n = 1:n_freq
    [disp_snr(n), strain_snr(n), lap_snr(n)] = mre_snr(img_resh(:,:,:,:,n), spacing, mask);
end
    