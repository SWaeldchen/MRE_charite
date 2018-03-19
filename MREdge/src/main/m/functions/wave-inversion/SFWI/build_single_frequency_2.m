function [K, f, ord_vec, sz_pad] = build_single_frequency_2(U, freq, spacing, diff_meth)

% + TEST EB
% spacing = spacing*2;
% - TEST EB

RHO = 1050;
J = 1;

if ndims(U) ~= 4
    disp('4D only, with 3 as size of 4th dim');
    return;
end

[U, ord_vec] = pad_for_inversion(U);
sz_pad = size(U);

xyz = [1 2 3];
U_x = U(:,:,:,xyz(1));
U_y = U(:,:,:,xyz(2));
U_z = U(:,:,:,xyz(3));

if diff_meth == 1
    [x_x, x_y, x_z] = gradient(U_x, spacing(1), spacing(2), spacing(3));
    [y_x, y_y, y_z] = gradient(U_y, spacing(1), spacing(2), spacing(3));
    [z_x, z_y, z_z] = gradient(U_z, spacing(1), spacing(2), spacing(3));
elseif diff_meth == 2
    [x_x, x_y, x_z] = get_diffs(U_x, spacing);
    [y_x, y_y, y_z] = get_diffs(U_y, spacing);
    [z_x, z_y, z_z] = get_diffs(U_z, spacing);
elseif diff_meth == 3
    [x_x, x_y, x_z] = wavelet_gradients_stationary(U_x, J, spacing);
    [y_x, y_y, y_z] = wavelet_gradients_stationary(U_y, J, spacing);
    [z_x, z_y, z_z] = wavelet_gradients_stationary(U_z, J, spacing);
end

x_diags = [0 sz_pad(1)];
y_diags = [0 1];
z_diags = [0 sz_pad(1)*sz_pad(2)];

L = numel(x_x);
spdiag = @(x) spdiags(x(:), 0, L, L);


div_grad_x = get_compact_laplacian(U_x, spacing, 0);
div_grad_y = get_compact_laplacian(U_y, spacing, 0);
div_grad_z = get_compact_laplacian(U_z, spacing, 0);

diag_1_1_1 = spdiags([-x_x(:) x_x(:)]./spacing(1), x_diags, L, L);
diag_1_2_2 = spdiags([-x_y(:) x_y(:)]./spacing(2), y_diags, L, L);
diag_1_2_1 = spdiags([-x_y(:) x_y(:)]./spacing(1), x_diags, L, L);
diag_1_3_3 = spdiags([-x_z(:) x_z(:)]./spacing(3), z_diags, L, L);
diag_1_3_1 = spdiags([-x_z(:) x_z(:)]./spacing(1), x_diags, L, L);

diag_2_1_2 = spdiags([-y_x(:) y_x(:)]./spacing(2), y_diags, L, L);
diag_2_1_1 = spdiags([-y_x(:) y_x(:)]./spacing(1), x_diags, L, L);
diag_2_2_2 = spdiags([-y_y(:) y_y(:)]./spacing(2), y_diags, L, L);
diag_2_3_2 = spdiags([-y_z(:) y_z(:)]./spacing(2), y_diags, L, L);
diag_2_3_3 = spdiags([-y_z(:) y_z(:)]./spacing(3), z_diags, L, L);

diag_3_1_3 = spdiags([-z_x(:) z_x(:)]./spacing(3), z_diags, L, L);
diag_3_1_1 = spdiags([-z_x(:) z_x(:)]./spacing(1), x_diags, L, L);
diag_3_2_3 = spdiags([-z_y(:) z_y(:)]./spacing(3), z_diags, L, L);
diag_3_2_2 = spdiags([-z_y(:) z_y(:)]./spacing(2), y_diags, L, L);
diag_3_3_3 = spdiags([-z_z(:) z_z(:)]./spacing(3), z_diags, L, L);

x_dir = diag_1_1_1 + (diag_2_1_1 + diag_1_2_1)/2 + (diag_1_3_1 + diag_3_1_1)/2; % + spdiag(div_grad_x); 
y_dir = diag_2_2_2 + (diag_1_2_2 + diag_2_1_2)/2 + (diag_2_3_2 + diag_3_2_2)/2; % + spdiag(div_grad_y);
z_dir = diag_3_3_3 + (diag_2_3_3 + diag_3_2_3)/2 + (diag_1_3_3 + diag_3_1_3)/2; % + spdiag(div_grad_z);
K = [x_dir; y_dir; z_dir];
% + TEST EB
% K = real(K);
% - TEST EB
om = @(x) 2*pi*x;
f = -RHO*om(freq).^2*vec(U);

end

function [diff_x, diff_y, diff_z] = get_diffs(vol, spacing)

diff_y = diff(vol, 1, 1) ./ spacing(1);
diff_y = cat(1, diff_y, diff_y(end,:,:));
diff_x = diff(vol, 1, 2) ./ spacing(2);
diff_x = cat(2, diff_x, diff_x(:,end,:));
diff_z = diff(vol, 1, 3) ./ spacing(3);
diff_z = cat(3, diff_z, diff_z(:,:,end));

end