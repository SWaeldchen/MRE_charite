% function Du = DUdxdz(u,[dx,dy,dz],i,j,k)
%
% Evaluate local term for int_(north-south) du/dx_i dxdz
%
% matrix 'u' is an NxMxL array built using meshgrid
%
function Du = DUdxdz(u,D,i,j,k)

Du = zeros(3,1);
Du(1) = 0.25*D(3)*(u(i-1,j+1,k) + u(i+1,j-1,k) - u(i+1,j+1,k) - u(i-1,j-1,k));
Du(2) = D(1)*D(3)/D(2)*(u(i,j+1,k) - 2*u(i,j,k) + u(i,j-1,k));
Du(3) = 0.25*D(1)*(u(i,j-1,k+1) + u(i,j+1,k-1) - u(i,j-1,k-1) - u(i,j+1,k+1));

return