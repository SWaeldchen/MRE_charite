
function [mu, alpha, delta] = singlePointTest(m, n, p, eta, freqs, storComps, lossComps)

numfreqs = numel(freqs);

alfa_vek = linspace(0.01,0.99,98); % 197
mu_vek = linspace(500, 30000, 30); %(100,15000,791);

volDepth = size(storComps, 3) / numfreqs;


for q = 1:numfreqs
G(q) = storComps(m, n, (q-1)*volDepth + p) + 1i*lossComps(m, n, (q-1)*volDepth + p);
end

[mu,alpha,delta] = springpot_inv_english(freqs,eta,mu_vek,alfa_vek,G,2);

