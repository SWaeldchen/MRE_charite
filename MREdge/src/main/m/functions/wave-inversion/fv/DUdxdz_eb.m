% function Du = DUdxdz(u,[dx,dy,dz],i,j,k)
%
% Evaluate local term for int_(north-south) du/dx_i dxdz
%
% matrix 'u' is an NxMxL array built using meshgrid
%
function Du = DUdxdz_eb(u,D)


Du1 = 0.25*D(3)*( u(1:end-2, 3:end, 2:end-1, :, :) + u(3:end, 1:end-2, 2:end-1, :, :) - ...
                    u(3:end, 3:end, 2:end-1, :, :) - u(1:end-2, 1:end-2, 2:end-1, :, :) ) ; 
Du2 = D(1)*D(3)/D(2)*( u(2:end-1, 3:end, 2:end-1, :, :) - 2*u(2:end-1, 2:end-1, 2:end-1, :, :) + ...
                         u(2:end-1, 1:end-2, 2:end-1, :, :) );
Du3 = 0.25*D(1)*( u(2:end-1, 1:end-2, 3:end, :, :) + u(2:end-1, 3:end, 1:end-2, :, :) - ...
                    u(2:end-1, 1:end-2, 1:end-2, :, :) - u(2:end-1, 3:end, 3:end, :, :) );
                
Du = cat(6, Du1, Du2, Du3);