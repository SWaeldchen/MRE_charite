function mu2=mu1eta2muxeta(mu1,alpha,eta)
%
% mu2=mu1eta2muxeta(mu1,alpha,eta)
% 
% springpot model G* = mu1^(1-alpha)*(i*omega*eta)^alpha
% mu1 corresponds to kappa with eta = 1 Pas:
% kappa^(1-alpha)=mu2^(1-alpha)*eta^alpha
% mu2 corresponds to arbitrary eta
% mu2=eta^(1/(-1+alpha)*alpha)*mu1;
% see mu@eta=1tomu@etaxx.mws

mu2=eta.^(1./(-1+alpha).*alpha).*mu1;