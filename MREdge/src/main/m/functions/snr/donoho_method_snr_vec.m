function [snr, sigma_s, sigma_n] = donoho_method_snr_vec(x, mask)
% ensure vector is of pwr2 length

if nargin < 2
    mask = ones(size(x));
end
x = x(:);
mask = mask(:);
L = nextpwr2(numel(x));
x = [x; x];
mask = [mask; mask];
x = x(1:L);
mask = mask(1:L);

mask = logical(mask);
mask_down = mask(1:2:end);
signalpwr = @(x) sum(abs(x(mask)).^2)/length(x(mask));

sigpwr = signalpwr(x);
sigma_s = sqrt(sigpwr);

af = farras;
w = dwt(x, 1, af);
w_noise_vec = w{1};
sigma_n = simplemad(w_noise_vec(mask_down)) / 0.6745;
snr = 20*log10(sigma_s / sigma_n);
% alternate equivalent
%snr = 10*log10(sigpwr / sigma_n.^2);
