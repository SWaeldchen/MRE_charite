function h=drumhead_eigenmodes(r,rho,F,f,m,n);
%
% see maple file drumhead_eigenmodes.mws
%

BZ = [2.404825558 5.520078110 8.653727913 11.79153444; ...
      3.831705970 7.015586670 10.17346814 13.32369194; ...
      5.135622302 8.417244140 11.61984117 14.79595178];

mu = f^2/BZ(m,n+1)^2*r^2*rho;
h = sqrt(6*mu*pi*r^2*F-F.^2)*r./(3*mu*pi*r^2-F);
