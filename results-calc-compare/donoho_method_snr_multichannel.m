function [snr, sigma_s, sigma_n] = donoho_method_snr_multichannel(x, mask)

if nargin < 2
    mask = ones(size(x));
end
% for 4D data, evaluates slicewise across three channels
sz = size(x);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end
if numel(sz) < 4
    d4 = 1;
else
    d4 = sz(4);
end
snr = zeros(size(d5, 1));
for i = 1:d5
    sigma_s = 0;
    sigma_n = 0;
    for j = 1:sz(3)
        for k = 1:d4
            [snr, chan_sigma_s_k, chan_sigma_n_k] = donoho_method_snr(x(:,:,j,k,i), mask(:,:,j));
            sigma_s = sigma_s + chan_sigma_s_k;
            sigma_n = sigma_n + chan_sigma_n_k;
        end
    end
    snr(i) = 20*log10(sigma_s / sigma_n);
end
