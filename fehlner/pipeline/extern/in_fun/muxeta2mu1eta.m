function mu1=muxeta2mu1eta(mu2,alpha,eta)
%
% mu1=muxeta2mu1eta(mu2,alpha,eta)
% 
% springpot model G* = mu1^(1-alpha)*(i*omega*eta)^alpha
% mu1 corresponds to kappa with eta = 1 Pas:
% kappa^(1-alpha)=mu2^(1-alpha)*eta^alpha
% mu2 corresponds to arbitrary eta
% mu2=eta^(1/(-1+alpha)*alpha)*mu1;
% see mu@eta=1tomu@etaxx.mws

%mu2=eta^(1/(-1+alpha)*alpha)*mu1;
mu1=mu2*eta^(-1/(-1+alpha)*alpha);