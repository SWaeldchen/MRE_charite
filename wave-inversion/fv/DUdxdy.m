% function Du = DUdxdy(u,[dx,dy,dz],i,j,k)
%
% Evaluate local term for int_(front-back) du/dx_i dxdy
%
% matrix 'u' is an NxMxL array built using meshgrid
%
function Du = DUdxdy(u,D,i,j,k)

Du = zeros(3,1);
Du(1) = 0.25*D(2)*(u(i-1,j,k+1) + u(i+1,j,k-1) - u(i+1,j,k+1) - u(i-1,j,k-1));
Du(2) = 0.25*D(1)*(u(i,j-1,k+1) + u(i,j+1,k-1) - u(i,j-1,k-1) - u(i,j+1,k+1));
Du(3) = D(1)*D(2)/D(3)*(u(i,j,k+1) - 2*u(i,j,k) + u(i,j,k-1));

return