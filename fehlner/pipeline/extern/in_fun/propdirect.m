function [GX, GY]=propdirect(U0,U90,tol,arrowlength,smoothgauss)
%
% propdirect(U0,U90,tol,arrowlength,smoothgauss)
%
if nargin < 5
    smoothgauss=0;
end

phi=atan2(U0, U90);
[GX, GY]=gradient(phi);

[z, s]=find(abs(GX) > tol);

for k=1:length(z) 
    
    if s(k)-1 > 0
    GX(z(k),s(k))=GX(z(k),s(k)-1); 
    else
    GX(z(k),s(k))=GX(z(k),s(k)+1);
    end
end

[z, s]=find(abs(GY) > tol);
for k=1:length(z) 
    if z(k)-1 > 0
    GY(z(k),s(k))=GY(z(k)-1,s(k)); 
    else
    GY(z(k),s(k))=GY(z(k)+1,s(k)); 
    end
end
if smoothgauss
GX=smoothgaussconv(GX,smoothgauss);
GY=smoothgaussconv(GY,smoothgauss);
end

plot2dwaves(U0,'cccccccccccccccccccccc')
hold on

si=size(U0);
[x,y] = meshgrid(1:2:si(2),1:2:si(1));

quiver(x,y,GX(1:2:end,1:2:end),GY(1:2:end,1:2:end),arrowlength)

plot2dwaves(sqrt(GX.^2+GY.^2))