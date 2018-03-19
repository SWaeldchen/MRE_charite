% function Du = DUdxdy(u,[dx,dy,dz],i,j,k)
%
% Evaluate local term for int_(front-back) du/dx_i dxdy
%
% matrix 'u' is an NxMxL array built using meshgrid
%
function Du = DUdxdy_eb(u,D)

Du1 = 0.25*D(2)*( u(1:end-2, 2:end-1, 3:end, :, :) + u(3:end, 2:end-1, 1:end-2, :, :) - ...
                    u(3:end, 2:end-1, 3:end, :, :) - u(1:end-2, 2:end-1, 1:end-2, :, :) );
Du2 = 0.25*D(1)*( u(2:end-1, 1:end-2, 3:end, :, :) + u(2:end-1, 3:end, 1:end-2, :, :) - ...
                    u(2:end-1, 1:end-2, 1:end-2, :, :) - u(2:end-1, 3:end, 3:end, :, :) );
Du3 = D(1)*D(2)/D(3)*( u(2:end-1, 2:end-1, 3:end, :, :) - 2* u(2:end-1, 2:end-1, 2:end-1, :, :) + ...
                            u(2:end-1, 2:end-1, 1:end-2, :, :) );
                        
Du = cat(6, Du1, Du2, Du3);