function [optMu, optEta, optAlpha, deltaMap] = fit_schiessel_pot(Gvec, freqs)

    muRange = 1:1:30;
    etaRange = 2:2:100;
    alphaRange = 0:0.1:3;
    [freqs, mu, eta, alpha] = ndgrid(freqs, muRange,  etaRange, alphaRange);
    Gmod = schiessel_pot(mu, eta, alpha, freqs); % schiessel pot
    Gobs = repmat(Gvec, 1, size(mu,2), size(mu,3), size(mu,4));
    deltas = (abs(Gmod) - abs(Gobs)).^2;
    deltaMap = squeeze(sum(deltas, 1));
    [M, I] = min(deltaMap(:));
    [mu, eta, alpha] = ndgrid(muRange, etaRange, alphaRange);
    %display(['min delta ', num2str(M)]);
    optMu = mu(I);
    optEta = eta(I);
    optAlpha = alpha(I);
    
    
    