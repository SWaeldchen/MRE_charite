function [optMu, optAlpha, deltaMap] = fit_schiessel_pot_two_param(Gvec, omega)

    muRange = 100:100:10000;
    %etaRange = 2:2:100;
    eta = 50;
    alphaRange = 0.1:0.02:0.8;
    [f, mu, alpha] = ndgrid(omega, muRange, alphaRange);
    Gmod = schiessel_pot(mu, eta, alpha, f); % schiessel pot
    %Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*f).^alpha;
    Gobs = repmat(Gvec, 1, size(mu,2), size(mu,3));
    deltas = abs(Gmod - Gobs);
    deltaMap = squeeze(sum(deltas, 1));
    deltaMap = deltaMap';
    [M, I] = min(deltaMap(:));
    [mu2, alpha2] = meshgrid(muRange, alphaRange);
    %display(['min delta ', num2str(M)]);
    optMu = mu2(I);
    optEta = 1;
    optAlpha = alpha2(I);
    
    
    