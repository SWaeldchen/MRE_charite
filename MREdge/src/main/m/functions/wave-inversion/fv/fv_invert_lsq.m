function [G_sep, G_comb] = fv_invert_lsq(U, freq, spacing)

sz = size(U);
sz_adj = sz-2;

Ux = squeeze(U(:,:,:,2,:));
Uy = squeeze(U(:,:,:,1,:));
Uz = squeeze(U(:,:,:,3,:));
dx = spacing(2);
dy = spacing(1);
dz = spacing(3);
rho = 1000;
dot4d = @(x,y) sum(conj(x).*y,4);
dot5d = @(x,y) sum(conj(x).*y,5);
crop = @(x) x(2:end-1, 2:end-1, 2:end-1,:,:);

U_xy = DUdxdy_eb(U, spacing);
[dUx,Ux] = gradestim4d(Ux,spacing);
[dUy,Uy] = gradestim4d(Uy,spacing);
[dUz,Uz] = gradestim4d(Uz,spacing);
x_x = dUx(:,:,:,2);
x_y = dUx(:,:,:,1);
x_z = dUx(:,:,:,3);
y_x = dUy(:,:,:,2);
y_y = dUy(:,:,:,1);
y_z = dUy(:,:,:,3);
z_x = dUz(:,:,:,2);
z_y = dUz(:,:,:,1);
z_z = dUz(:,:,:,3);

E = {   { x_x         }  {(x_y + y_x)/2}  {(x_z + z_x)/2}    ;   ...
    {(y_x + x_y)/2}  { y_y         }  {(y_z + z_y)/2}    ;   ...
    {(z_x + x_z)/2}  {(z_y + y_z)/2}  {z_z          }     };



b_x = cat(5, ...
    Uxyz(:,:,:,:,1), ...
    0.5*(Uxyz(:,:,:,:,2)+Uyyz(:,:,:,:,1)), ...
    0.5*(Uxyz(:,:,:,:,3)+Uzyz(:,:,:,:,1)));
b_y = cat(5, ...
    0.5*(Uxxz(:,:,:,:,2)+Uyxz(:,:,:,:,1)), ...
    Uyxz(:,:,:,:,2), ...
    0.5*(Uyxz(:,:,:,:,3)+Uzxz(:,:,:,:,2)));
b_z = cat(5, ...
    0.5*(Uxxy(:,:,:,:,3)+Uzxy(:,:,:,:,1)), ...
    0.5*(Uyxy(:,:,:,:,3)+Uzxy(:,:,:,:,2)), ...
    Uzxy(:,:,:,:,3));

b = b_x + b_y + b_z;
p = cat(5, crop(Ux)*dx*dy*dz, crop(Uy)*dx*dy*dz, crop(Uz)*dx*dy*dz);

om_5d = ones(1, 1, 1, numel(freq));
om_5d(:) = (2*pi*freq).^2;
om_rep_5d = repmat(om_5d, [sz_adj(1), sz_adj(2), sz_adj(3) 1 3]);
G_sep = (-1/dot5d(b,b)).*dot5d(b,rho*om_rep_5d.*p);

om_rep_4d = resh(om_rep_5d, 4);
b = resh(b, 4);
p = resh(p, 4);
G_comb = (-1/dot4d(b,b)) .* dot4d(b,rho*om_rep_4d.*p);

end

function Du = DUdxdy_eb(u,D)

Du1 = 0.25*D(2)*( u(1:end-2, 2:end-1, 3:end, :, :) + u(3:end, 2:end-1, 1:end-2, :, :) - ...
                    u(3:end, 2:end-1, 3:end, :, :) - u(1:end-2, 2:end-1, 1:end-2, :, :) );
Du2 = 0.25*D(1)*( u(2:end-1, 1:end-2, 3:end, :, :) + u(2:end-1, 3:end, 1:end-2, :, :) - ...
                    u(2:end-1, 1:end-2, 1:end-2, :, :) - u(2:end-1, 3:end, 3:end, :, :) );
Du3 = D(1)*D(2)/D(3)*( u(2:end-1, 2:end-1, 3:end, :, :) - 2* u(2:end-1, 2:end-1, 2:end-1, :, :) + ...
                            u(2:end-1, 2:end-1, 1:end-2, :, :) );
                        
Du = cat(6, Du1, Du2, Du3);

end

function Du = DUdxdz_eb(u,D)

Du1 = 0.25*D(3)*( u(1:end-2, 3:end, 2:end-1, :, :) + u(3:end, 1:end-2, 2:end-1, :, :) - ...
                    u(3:end, 3:end, 2:end-1, :, :) - u(1:end-2, 1:end-2, 2:end-1, :, :) ) ; 
Du2 = D(1)*D(3)/D(2)*( u(2:end-1, 3:end, 2:end-1, :, :) - 2*u(2:end-1, 2:end-1, 2:end-1, :, :) + ...
                         u(2:end-1, 1:end-2, 2:end-1, :, :) );
Du3 = 0.25*D(1)*( u(2:end-1, 1:end-2, 3:end, :, :) + u(2:end-1, 3:end, 1:end-2, :, :) - ...
                    u(2:end-1, 1:end-2, 1:end-2, :, :) - u(2:end-1, 3:end, 3:end, :, :) );
                
Du = cat(6, Du1, Du2, Du3);

end

function Du = DUdydz_eb(u,D)

Du1 = (D(2)*D(3)/D(1))*( u(3:end,2:end-1,2:end-1, :, :) - 2*u(2:end-1,2:end-1,2:end-1, :, :) + ...
                           u(1:end-2,2:end-1,2:end-1, :, :) );
Du2 = 0.25*D(3)*(u(3:end,3:end,2:end-1, :, :) - u(3:end,1:end-2,2:end-1, :, :) - ...
                   u(1:end-2,3:end,2:end-1, :, :) + u(1:end-2,1:end-2,2:end-1, :, :) );
Du3 = 0.25*D(2)*(u(3:end,2:end-1,3:end, :, :) - u(3:end,2:end-1,1:end-2, :, :) - ...
                   u(1:end-2,2:end-1,3:end, :, :) + u(1:end-2,2:end-1,1:end-2, :, :));
               
Du = cat(6, Du1, Du2, Du3);

end

function [y, final_dim_size] = resh(x, d)

sz = size(x);
final_dim_size = prod(sz(d:end));
y = reshape(x, [sz(1:d-1) final_dim_size]);

end