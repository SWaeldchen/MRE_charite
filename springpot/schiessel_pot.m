function [Gvec] = schiessel_pot(mu, eta, alpha, omegas)

Gvec = mu.*(1i.*omegas.*eta./mu).^alpha;