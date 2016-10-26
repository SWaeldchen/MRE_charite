function [optMu, optAlpha] = fitSchiessel3(storVec, lossVec, freqs, flag)
    eta = 3;
    optMu = 0;
    optAlpha = 0;
    optDelta = 1e12; % serving as a MAX_VALUE
    
    Gvec = storVec + 1i*lossVec;
    
    [mu, alpha, eta, omega] = ndgrid(200:200:4000,  0.1:0.02:0.9, 1:0.1:6, freqs*2*pi);
    [~, ~, ~, Gobs] = ndgrid(200:200:4000,  0.1:0.02:0.9, 1:0.1:6, Gvec);
       
    Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*omega).^alpha;
    %Gmod = schiessel_pot(mu, eta, alpha, omega);
    
    delta = sum(  abs(Gmod - Gobs), 3   );
       
    [~, ind] = min(delta(:));
    [deltamins, indices] = min(delta);
    deltamins = conv(deltamins, ones(1,7)./7, 'same');
    deltamins = deltamins(3:end-3);
    %if flag > 0
        %figure();
        %plot(mu(indices));
       % openImage(delta);
    %end
    [~, index] = min(deltamins);
    ycoord = indices(index+3);
    xcoord = index+3;
    optAlpha = alpha(ycoord, xcoord);
    optMu = mu(ycoord, xcoord);
   
    