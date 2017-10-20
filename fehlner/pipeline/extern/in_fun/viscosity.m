function [n, Gamma2]=viscosity(gamma,c,f, rho, f2)
% viscosity by Voigt's model
% n=viscosity(gamma,c,f, rho, f2)
%

omega=2*pi*f;
k=omega/c;

tmp=(i*k-gamma).^2;

eta=rho*(-omega.^2-c.^2*tmp)./(i*omega.*tmp);
n=abs(eta);


if nargin > 4
   eta=n; 
omega=2*pi*f2;
k=omega/c;

% Gamma2=-real(1./2./(-i.*rho.*c.^2+2.*eta.*pi.*f2).*...
%    (8.*i.*eta.*pi.^2.*f2+4.*c.^2.*rho.*pi+...
%    4.*sqrt(2.*i.*eta.*pi.^3.*f2.*c.^2.*rho+c.^4.*rho.^2.*pi.^2)).*f2./c);

tmp=eta*omega-i*rho*c^2;
Gamma2=(sqrt(i*rho)*omega./sqrt(tmp)+i*k);
end