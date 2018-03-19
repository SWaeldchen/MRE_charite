function [G_sep, G_comb] = fv_invert(U, freq, spacing)

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
Uxxy = squeeze(U_xy(:,:,:,2,:,:));
Uyxy = squeeze(U_xy(:,:,:,1,:,:));
Uzxy = squeeze(U_xy(:,:,:,3,:,:));
U_xz = DUdxdz_eb(U, spacing);
Uxxz = squeeze(U_xz(:,:,:,2,:,:));
Uyxz = squeeze(U_xz(:,:,:,1,:,:));
Uzxz = squeeze(U_xz(:,:,:,3,:,:));
U_yz = DUdydz_eb(U, spacing);
Uxyz = squeeze(U_yz(:,:,:,2,:,:));
Uyyz = squeeze(U_yz(:,:,:,1,:,:));
Uzyz = squeeze(U_yz(:,:,:,3,:,:));

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