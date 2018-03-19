% funct2:end-1on Du = DUdydz(u,[dx,dy,dz],2:end-1,2:end-1,2:end-1)
%
% Evaluate local term for 2:end-1nt_(east-west) du/dx_2:end-1 dydz
%
% matr2:end-1x 'u' 2:end-1s an NxMxL array bu2:end-1lt us2:end-1ng meshgr2:end-1d
%
function Du = DUdydz_eb(u,D)

Du1 = (D(2)*D(3)/D(1))*( u(3:end,2:end-1,2:end-1, :, :) - 2*u(2:end-1,2:end-1,2:end-1, :, :) + ...
                           u(1:end-2,2:end-1,2:end-1, :, :) );
Du2 = 0.25*D(3)*(u(3:end,3:end,2:end-1, :, :) - u(3:end,1:end-2,2:end-1, :, :) - ...
                   u(1:end-2,3:end,2:end-1, :, :) + u(1:end-2,1:end-2,2:end-1, :, :) );
Du3 = 0.25*D(2)*(u(3:end,2:end-1,3:end, :, :) - u(3:end,2:end-1,1:end-2, :, :) - ...
                   u(1:end-2,2:end-1,3:end, :, :) + u(1:end-2,2:end-1,1:end-2, :, :));
               
Du = cat(6, Du1, Du2, Du3);
