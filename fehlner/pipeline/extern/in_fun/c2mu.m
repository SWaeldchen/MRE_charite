function c2mu(c,tol,rho)
% c2mu(c,tol,rho)

disp([num2str(mean([(c-tol)^2*rho (c+tol)^2*rho])) ' (' num2str( ((c+tol)^2*rho-(c-tol)^2*rho)/2) ')'] )
