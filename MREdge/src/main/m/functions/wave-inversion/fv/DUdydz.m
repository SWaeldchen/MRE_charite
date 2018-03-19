% function Du = DUdydz(u,[dx,dy,dz],i,j,k)
%
% Evaluate local term for int_(east-west) du/dx_i dydz
%
% matrix 'u' is an NxMxL array built using meshgrid
%
function Du = DUdydz(u,D,i,j,k)

Du = zeros(3,1);
Du(1) = (D(2)*D(3)/D(1))*( u(i+1,j,k) - 2*u(i,j,k) + u(i-1,j,k) );
Du(2) = 0.25*D(3)*(u(i+1,j+1,k) - u(i+1,j-1,k) - u(i-1,j+1,k) + u(i-1,j-1,k));
Du(3) = 0.25*D(2)*(u(i+1,j,k+1) - u(i+1,j,k-1) - u(i-1,j,k+1) + u(i-1,j,k-1));

return
