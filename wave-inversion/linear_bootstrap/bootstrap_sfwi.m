function [x0, x1, invs] = bootstrap_sfwi(preproc, freqvec, spacing)
%
% INPUTS
% preproc - denoised complex wave image
% freqvec - vector of frequencies (Hz)
% spacing - vector of pixel spacings
%
% OUTPUTS
% b - image representing intercept
% m - image representing voit model viscosity

sz = size(preproc);
num_vox = prod(sz(1:3));
n_freqs = numel(freqvec);
amps = squeeze(sum(abs(preproc), 4));
% TEST+
% amps = ones(size(amps));
% TEST-
freqvec_adj = ones(1, 1, 1, numel(freqvec));
freqvec_adj(:) = freqvec;
freq_block = repmat(freqvec_adj, [sz(1) sz(2) sz(3) 1]);
freq_weighted_amps = freq_block .* amps;
A = [];
b = [];
invs = [];
MIN_COMB = 5;
for n = MIN_COMB:n_freqs
    disp(n)
    combs = nchoosek(1:n_freqs, n);
    for c = 1:size(combs,1)
        inv = sfwi_inversion(preproc(:,:,:,:,combs(c,:)), freqvec(combs(c,:)), spacing, [1 2 3], 1, 2);
        invs = cat(4, invs, inv);
        sum_amps = vec(sum(amps(:,:,:,combs(c,:)),4));
        sum_freq_weighted_amps = vec(sum(freq_weighted_amps(:,:,:,combs(c,:)),4));
        b = cat(1, b, inv(:).*sum_amps);
        a0 = vec(sum_amps);
        a1 = vec(sum_freq_weighted_amps);
        A = cat(1, A, [spdiag(a0), spdiag(a1)]);
    end
end
x = A \ b;
x0 = reshape(x(1:num_vox), sz(1:3));
x1 = reshape(x(num_vox+1:end), sz(1:3));