function x = additive_sr_backslash(b, super_factor)

sz = size(b);
b_vec = double(b(:));
sz_super = sz*super_factor;

% make bands
y_diags = [-1 1];
x_diags = [-sz_super(1) sz_super(1)];
z_diags = [-sz_super(1)*sz_super(2) sz_super(1)*sz_super(2)];

N = numel(b_vec)*super_factor;
ones_cols = ones(N, 2);
I = speye(N);

% make full additive matrix
additive_y = spdiags(ones_cols, y_diags, N, N);
additive_x = spdiags(ones_cols, x_diags, N, N);
additive_z = spdiags(ones_cols, z_diags, N, N);

A = I + additive_x + additive_y + additive_z;

%remove every other row
A = A(1:super_factor:end, :);

x_vec = A \ b_vec;

x = reshape(x_vec, sz*super_factor);