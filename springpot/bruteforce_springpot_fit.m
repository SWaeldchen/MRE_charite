function [optMu, optAlpha, optDelta] = bruteforce_springpot_fit(wvec, Gvec, eta)
   
    if nargin < 3 
        eta = 1;
    end
    muRange = 200:200:20000;
    alphaRange = 0.1: 0.01: 0.9;
    
    [mu, alpha, omega] = ndgrid(muRange, alphaRange, wvec);
    [~, ~, Gobs] = ndgrid(muRange, alphaRange, Gvec);
       
    Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*omega).^alpha;
    
    delta = sqrt(sum(  abs(Gmod - Gobs).^2, 3   ));
   
    [optDelta, index] = min(delta(:));
       
    optAlpha = alpha(index);
    optMu = mu(index);
 
