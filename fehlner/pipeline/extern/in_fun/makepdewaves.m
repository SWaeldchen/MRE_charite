function U=makepdewaves(p,t,u,si)
%
% U=makepdewaves(p,t,u,size)
% make waves from triangular mesh as calculated in the pde toolbox
% 4 plots are shown:
% U(:,:,1)=realux    U(:,:,2)=imagux
% U(:,:,3)=realuy    U(:,:,4)=imaguy
%

if size(si,2) == 1
    si=[si si];
end

X=linspace(min(p(1,:)),max(p(1,:)),si(2));
Y=linspace(min(p(2,:)),max(p(2,:)),si(1));

ux=u(1:size(p,2));
UXYx=tri2grid(p,t,ux,X,Y);

if size(u,1) == 2*size(p,2)
uy=u(size(p,2)+1:2*size(p,2));
UXYy=tri2grid(p,t,uy,X,Y);
else
    UXYy=[];
end

U=cat(3,real(rot90(UXYx,2)),imag(rot90(UXYx,2)),real(rot90(UXYy,2)),imag(rot90(UXYy,2)));



