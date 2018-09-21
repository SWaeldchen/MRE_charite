function [mu] = invert_for_mu_2d(u, freqVec, muCorners)
%INVERT_FOR_MU_2D Summary of this function goes here
%   Detailed explanation goes here

dim.x = 1; dim.y = 2;

[sz(1), sz(2), ~, numofFreq] = size(u);
gridSize = max(sz);

diff_x = @(v) convn(v, diff_kernel_2(dim.x, dim.y), 'valid');
diff_y = @(v) convn(v, diff_kernel_2(dim.y, dim.x), 'valid');
diff_xx = @(v) convn(v, diff_kernel_2([dim.x, dim.x], dim.y), 'valid');
diff_xy = @(v) convn(v, diff_kernel_2([dim.x, dim.y], []), 'valid');
diff_yy = @(v) convn(v, diff_kernel_2([dim.y, dim.y], dim.x), 'valid');

%%% D_u mu = (Nabla mu)*E + mu Nabla*E = - omega^2 * u

Op = [];
rhside = [];

%%% Nabla

Nabla = nabla(sz);
P_inner = speye(prod(sz));
P_inner(bound(sz),:) = [];
P_corners = speye(prod(sz));
P_corners = P_corners(corners(sz),:);


for freq = 1: numofFreq

    %%% shear tensor E

    u_x = u(:,:,dim.x, freq);
    u_y = u(:,:,dim.y, freq);

    E{1,1} = 2*diff_x(u_x); E{1,2} = diff_x(u_y) + diff_y(u_x); 
    E{2,1} = diff_y(u_x) + diff_x(u_y); E{2,2} = 2*diff_y(u_y);
    
    %%% Nabla*E

    Nabla_E{1,1} = 2*diff_xx(u_x) + diff_yy(u_x) + diff_xy(u_y);
    Nabla_E{2,1} = 2*diff_yy(u_y) + diff_xx(u_y) + diff_xy(u_x);

    %%% D_u mu

    D_u_x = sparse(E{1,1}(:)).*Nabla{1} + sparse(E{1,2}(:)).*Nabla{2} + sparse(Nabla_E{1,1}(:)).*P_inner;
    D_u_y = sparse(E{2,1}(:)).*Nabla{1} + sparse(E{2,2}(:)).*Nabla{2} + sparse(Nabla_E{2,1}(:)).*P_inner;

    D_u = [D_u_x; D_u_y];    
    Op = [Op; D_u];
    
    u_x_inner = u_x(2:end-1,2:end-1);
    u_y_inner = u_y(2:end-1,2:end-1);
    
    rhside = [rhside; (2*pi*freqVec(freq)/gridSize)^2*[u_x_inner(:); u_y_inner(:)]];
    
end

Op = [Op; P_corners];
rhside = [-rhside; muCorners];

mu = Op\rhside;

end

