function [optKappa, optAlpha] = fit_kappa_alpha(Gvec, freqs)

    optAlpha = 0;
    optDelta = 1e12; % serving as a MAX_VALUE
    optKappa = 0;
    
    eta = 1;

    for kappa = 1:1:10000
        %for eta = 0.5:0.5:10
            for alpha = 0.01:0.01:0.99
                delta = 0;
                for n = 1:numel(Gvec)
                    Gobs = Gvec(n);
                    freq = freqs(n);
                    Gmodel = kappa*(1i*2*pi*freq)^alpha;
                    delta = delta + abs(Gmodel-Gobs); % L1 NORM
                end
                if (delta < optDelta) 
                    optAlpha = alpha;
                    optDelta = delta;
                    optKappa = kappa;
                    %display([num2str(optMu), ' ', num2str(optEta), ' ', num2str(optAlpha), ' ', num2str(optDelta)]);
                end
                
            end
        %end
    end
    
    