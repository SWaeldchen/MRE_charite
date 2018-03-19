function [snr, sigma_s, sigma_n] = donoho_method_snr(x, mask)
if nargin < 2
    mask = ones(size(x));
end
mask = logical(mask);
mask_down = mask(1:2:end, 1:2:end);
signalpwr = @(x) sum(abs(x(mask)).^2)/length(x(mask));

sigpwr = signalpwr(x);
sigma_s = sqrt(sigpwr);

af = farras;
w = dwt2D(x, 1, af);
w_noise_img = w{1}{3};
sigma_n = simplemad(w_noise_img(mask_down)) / 0.6745;
snr = 20*log10(sigma_s / sigma_n);
% alternate equivalent
%snr = 10*log10(sigpwr / sigma_n.^2);
