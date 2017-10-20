function C=makeC(E,n)
% C=makeC(E,n)
% gives coefficient matrix due to Hooke's law
%



if length(E) == 3
  
 
    ET=E(1);
    EL=E(2);
    ELT=E(3);

    if EL == (4*ELT)
        
        disp('take moduli directly')
        c1=ET;
        c2=ET*n;
        c3=ET*n;
        c4=EL;
        
    else
    
disp(['transverse modulus: ' num2str(ET) ' longitudinal modulus: ' num2str(EL) ' shear modulus: ' num2str(ELT)]);
v=n;
%c1=-ET*(v^3*ET^2-v^3*ET*EL+2*v^2*ET*EL+v*EL^2-EL^2)/(-EL+2*v^2*ET+v^2*EL+2*v^3*ET)/EL/(v-1);
%c2=-v*ET*(v^2*ET^2+v^2*EL^2+v*ET*EL-EL^2)/(2*v^2*ET+v*EL-EL)/EL/(-1+v^2);
%c3=-v*ET*(v*EL-EL+v*ET)/(2*v^2*ET+v*EL-EL)/(v-1);
%c4=-(v^2*ET^2-v^2*EL^2+2*v*EL^2-EL^2)/(2*v^2*ET+v*EL-EL)/(v-1);
c1=-EL/(-EL+v^2*ET)*ET;
c2=-v*EL/(-EL+v^2*ET)*ET;
c3=-v*EL/(-EL+v^2*ET)*ET;
c4=-1/(-EL+v^2*ET)*EL^2;

end
C=[c1 0 0 ELT 0 c2 ELT 0 0 ELT c3 0 ELT 0 0 c4]';
 
elseif length(E) == 2
    G=E(1);
    v=n;
    R=E(2);
    disp(['transversal isotropy schear modulus: ' num2str(G) ' ratio: ' num2str(R)]);
    Ex = -1/R^3*G*v^2+1/R*G;
    Ez = -1/R*G*v^2+R*G;
    
    c1=-Ez/(-Ez+v^2*Ex)*Ex;
    c2=-v*Ez/(-Ez+v^2*Ex)*Ex;
    c3=-v*Ez/(-Ez+v^2*Ex)*Ex;
    c4=-1/(-Ez+v^2*Ex)*Ez^2;
    C=[c1 0 0 G 0 c2 G 0 0 G c3 0 G 0 0 c4]';
else
    
G=E/(2*(1+n));
m=2*G*(n/(1-n));

disp(['Shear modulus: ' num2str(G) ' Modulus: ' num2str(m)]);
C=[2*G+m 0 0 G 0 m G 0 0 G m 0 G 0 0 2*G+m]';

end

C2=reshape(C,[2 2 4]);

    EE=reshape([1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1],[2 2 4]);
    C3=zeros(4);
for k=1:4
    
    C3=C3+kron(EE(:,:,k),C2(:,:,k));
    
end

disp(C3)