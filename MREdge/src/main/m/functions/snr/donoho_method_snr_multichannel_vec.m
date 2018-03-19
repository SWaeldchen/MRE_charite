function [snr, sigma_s, sigma_n] = donoho_method_snr_multichannel_vec(x, mask)

if nargin < 2
    mask = ones(size(x));
end
% for 4D data, evaluates slicewise across three channels
sz = size(x);
[d3, d4, d5, ~] = sort_singletons(sz);

snr = zeros(d5,1);
sigma_s = zeros(d5);
sigma_n = zeros(d5);

for i = 1:d5
    img_sigma_s = zeros(d3, d4);
    img_sigma_n = zeros(d3, d4);
    n_vals  = d3*d4;
    for j = 1:d3
        for k = 1:d4
            [snr, chan_sigma_s, chan_sigma_n] = donoho_method_snr_vec(x(:,:,j,k,i), mask(:,:,j));
            img_sigma_s(j,k) = img_sigma_s(j,k) + chan_sigma_s;
            img_sigma_n(j,k) = img_sigma_n(j,k) + chan_sigma_n;
        end
    end
    sigma_s(i) = sum(vec(img_sigma_s)) / n_vals;
    sigma_n(i)  = sum(vec(img_sigma_n)) / n_vals;
    snr(i) = 20*log10(sigma_s(i) / sigma_n(i));
end