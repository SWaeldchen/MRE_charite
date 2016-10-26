function [optMu, optAlpha, optDelta] = bruteforce_springpot_fit_weighted(wvec, Gvec, weights_vec, eta)
   
    if nargin < 3 
        eta = 1;
    end
    muRange = 200:200:20000;
    alphaRange = 0.1: 0.01: 0.9;
    
    [mu, alpha, omega] = ndgrid(muRange, alphaRange, wvec);
    [~, ~, Gobs] = ndgrid(muRange, alphaRange, Gvec);
       
    Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*omega).^alpha;
    
	delta_grid = abs(Gmod - Gobs).^2;
	weights_shift = ones(1, 1, numel(weights_vec));
	weights_grid = repmat(weights_shift, [size(delta_grid, 1), size(delta_grid, 2)]);
	delta_weighted = delta_grid .* weights_grid;
    delta = sqrt( sum(delta_weighted, 3) );
   
    [optDelta, index] = min(delta(:));
       
    optAlpha = alpha(index);
    optMu = mu(index);
 
