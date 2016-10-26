function [K, f] = build_single_frequency_2D(U, freq, spacing)

if ndims(U) ~= 4
    disp('4D only, with 3 as size of 4th dim');
    return;
end

[x_x, x_y, x_z] = gradient(U(:,:,:,1), spacing(1), spacing(2), spacing(3));
[y_x, y_y, y_z] = gradient(U(:,:,:,2), spacing(1), spacing(2), spacing(3));
[z_x, z_y, z_z] = gradient(U(:,:,:,3), spacing(1), spacing(2), spacing(3));

sz = size(U);

x_diags = [0 sz(1)];
y_diags = [0 1];
z_diags = [0 sz(1)*sz(2)];

L = numel(x_x);

diag_1_1_1 = spdiags([-x_x(:) x_x(:)], x_diags, L, L);
diag_1_2_2 = spdiags([-x_y(:) x_y(:)], y_diags, L, L);
diag_1_2_1 = spdiags([-x_y(:) x_y(:)], x_diags, L, L);
diag_1_3_3 = spdiags([-x_z(:) x_z(:)], z_diags, L, L);
diag_1_3_1 = spdiags([-x_z(:) x_z(:)], x_diags, L, L);

diag_2_1_2 = spdiags([-y_x(:) y_x(:)], y_diags, L, L);
diag_2_1_1 = spdiags([-y_x(:) y_x(:)], x_diags, L, L);
diag_2_2_2 = spdiags([-y_y(:) y_y(:)], y_diags, L, L);
diag_2_3_2 = spdiags([-y_z(:) y_z(:)], y_diags, L, L);
diag_2_3_3 = spdiags([-y_z(:) y_z(:)], z_diags, L, L);

diag_3_1_3 = spdiags([-z_x(:) z_x(:)], z_diags, L, L);
diag_3_1_1 = spdiags([-z_x(:) z_x(:)], x_diags, L, L);
diag_3_2_3 = spdiags([-z_y(:) z_y(:)], z_diags, L, L);
diag_3_2_2 = spdiags([-z_y(:) z_y(:)], y_diags, L, L);
diag_3_3_3 = spdiags([-z_z(:) z_z(:)], z_diags, L, L);

x_dir = 2*diag_1_1_1 + diag_2_1_2 + diag_1_2_2; % + diag_3_1_3 + diag_1_3_3;
y_dir = 2*diag_2_2_2 + diag_1_2_1 + diag_2_1_1; % + diag_3_2_3 + diag_2_3_3;
z_dir = 2*diag_3_3_3 + diag_2_3_2 + diag_3_2_2 + diag_1_3_1 + diag_3_1_1;
K = [x_dir; y_dir]; %; z_dir];
om = @(x)2*pi*x;
f = -om(freq).^2*vec(U(:,:,:,1:2));