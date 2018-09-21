function [mu] = invert_for_mu_3d(u, freqVec, muCorners)
%INVERT_FOR_MU_2D Summary of this function goes here
%   Detailed explanation goes here

dim.x = 1; dim.y = 2; dim.z = 3;

[sz(1), sz(2), sz(3), ~, numofFreq] = size(u);
gridSize = max(sz);

% Create all the derivatives up to second degree one needs

diff_x = @(v) convn(v, diff_kernel_2(dim.x, [dim.y, dim.z]), 'valid');
diff_y = @(v) convn(v, diff_kernel_2(dim.y, [dim.z, dim.x]), 'valid');
diff_z = @(v) convn(v, diff_kernel_2(dim.z, [dim.x, dim.y]), 'valid');

diff_xx = @(v) convn(v, diff_kernel_2([dim.x, dim.x], [dim.y, dim.z]), 'valid');
diff_yy = @(v) convn(v, diff_kernel_2([dim.y, dim.y], [dim.z, dim.x]), 'valid');
diff_zz = @(v) convn(v, diff_kernel_2([dim.z, dim.z], [dim.x, dim.y]), 'valid');

diff_xy = @(v) convn(v, diff_kernel_2([dim.x, dim.y], [dim.z]), 'valid');
diff_zx = @(v) convn(v, diff_kernel_2([dim.z, dim.x], [dim.y]), 'valid');
diff_yz = @(v) convn(v, diff_kernel_2([dim.y, dim.z], [dim.x]), 'valid');

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
    
    u_x = u(:,:,:,dim.x, freq);
    u_y = u(:,:,:,dim.y, freq);
    u_z = u(:,:,:,dim.z, freq);
    
    E{1,1} = 2*diff_x(u_x);                E{1,2} = diff_x(u_y) + diff_y(u_x);     E{1,3} = diff_z(u_x) + diff_x(u_z); 
    E{2,1} = diff_x(u_y) + diff_y(u_x);     E{2,2} = 2*diff_y(u_y);                 E{2,3} = diff_y(u_z) + diff_z(u_y);
    E{3,1} = diff_z(u_x) + diff_x(u_z);     E{3,2} = diff_y(u_z) + diff_z(u_y);     E{3,3} = 2*diff_z(u_z);
    
    %%% Nabla*E

    Nabla_E{1,1} = 2*diff_xx(u_x) + diff_yy(u_x) + diff_xy(u_y) + diff_zx(u_z) + diff_zz(u_x);
    Nabla_E{2,1} = 2*diff_yy(u_y) + diff_xx(u_y) + diff_xy(u_x) + diff_yz(u_z) + diff_zz(u_y);
    Nabla_E{3,1} = 2*diff_zz(u_z) + diff_zx(u_x) + diff_xx(u_z) + diff_yy(u_z) + diff_yz(u_y);
    
%     Nabla_E{1,1}
    
    %%% D_u mu
    
    D_u_x = sparse(E{1,1}(:)).*Nabla{1} + sparse(E{1,2}(:)).*Nabla{2} + sparse(E{1,3}(:)).*Nabla{3} + sparse(Nabla_E{1,1}(:)).*P_inner;
    D_u_y = sparse(E{2,1}(:)).*Nabla{1} + sparse(E{2,2}(:)).*Nabla{2} + sparse(E{2,3}(:)).*Nabla{3} + sparse(Nabla_E{2,1}(:)).*P_inner;
    D_u_z = sparse(E{3,1}(:)).*Nabla{1} + sparse(E{3,2}(:)).*Nabla{2} + sparse(E{3,3}(:)).*Nabla{3} + sparse(Nabla_E{3,1}(:)).*P_inner;
    
    D_u = [D_u_x; D_u_y; D_u_z];
    
    Op = [Op; D_u];
    
    u_x_inner = u_x(2:end-1,2:end-1,2:end-1);
    u_y_inner = u_y(2:end-1,2:end-1,2:end-1);
    u_z_inner = u_z(2:end-1,2:end-1,2:end-1);
    
    rhside = [rhside; (2*pi*freqVec(freq)/gridSize)^2*[u_x_inner(:); u_y_inner(:); u_z_inner(:)]];
    
end

Op = [Op; P_corners];
rhside = [-rhside; muCorners];


mu = Op\rhside;

% mat = [Du_cell{1,1}; Du_cell{1,2}; Du_cell{2,1}; Du_cell{2,2}; Du_cell{1,3}; Du_cell{2,3}];
% mat = [Du_cell{1,1}; Du_cell{1,2}; Du_cell{2,1},];

% size(mat)
% rank(full(mat))

end

