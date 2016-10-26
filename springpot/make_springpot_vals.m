function [springpotVals] = make_springpot_vals(alpha, mu, eta, freqs)

springpotVals = mu.^(1-alpha).*eta.^(alpha).*(1i.*2*pi*freqs).^(alpha);
