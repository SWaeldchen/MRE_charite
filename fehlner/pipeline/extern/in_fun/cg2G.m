function G=cg2G(c,g,freqs)
% G=cg2G(c,g,freqs)

rho=1;
OM=ones(size(c,1),1)*freqs(:)'*2*pi;

G=rho*OM.^2./((OM./c - i*g).^2);