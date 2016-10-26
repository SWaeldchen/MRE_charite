function [mus, etas] = springpot_slope_test(storVec, lossVec, freqs, alpha)
    
   
    
    Gvec = storVec + 1i*lossVec;
    muRange = 2000:100:5000;
    etaRange = 1:0.1:100;
    
    
        [mu, eta, omega] = ndgrid(muRange, etaRange, freqs*2*pi);
        [~, ~,Gobs] = ndgrid(muRange, etaRange, Gvec);

        Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*omega).^alpha;

        delta = sum(  abs(Gmod - Gobs), 3   );
     
        [~, minEtaIndices] = min(delta, [], 2);

        etas = eta(1, minEtaIndices, 1);
        mus = muRange ;

        %smoothedEtas = conv(etas, [0.2 0.2 0.2 0.2 0.2], 'valid');
        smoothedEtas = conv(etas, fspecial('gaussian', [1 5], 1.95), 'valid');
        truncMus = mus(3:end-2);
        mus = truncMus;
        etas = smoothedEtas;