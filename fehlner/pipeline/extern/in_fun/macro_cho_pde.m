function [Ux, Uy]=macro_cho_pde(fac,G,omega)
%
% UX1:  fac1: fac=linspace(2,0.5,20)    G=33 omega=0.4 Anregung in der Mitte
% UX2:  fac2: fac=linspace(0.5,0.1,20)  G=33 omega=0.4 Anregung in der Mitte
% UX3:  fac3: fac=linspace(2,0.3,30)            ----"-----
% UX4:  fac=linspace(2,0.2,19)

C=makeC([G*fac^2 4*G G],0.5);
W=chomatrix(C,[100 100]);
F=zeros(100,100,2);
F(1,50,1)=1;
damp=ones(100)*0.01;damp(:,1)=100;damp(:,end)=100;damp(1,:)=100;damp(end,:)=100;
[Ux Uy]=cho_pde(W,F,omega,damp*10,0);