function x = additive_sr_backslash_1d(b)

sz = size(b);
b_vec = double(b(:));
super_factor = 2;
sz_super = [sz(1)*super_factor 1];

% make bands - only 1 for 1D
y_diags = 1;

% the matrix is fist built to SR dimensions, then columns are removed
N = prod(sz_super);
ones_cols = ones(N, 1);

% identity matrix, SR dimensions
I = speye(N);

% make additive matrix, SR dimensions
additive_y = spdiags(ones_cols, y_diags, N, N);

A = I + additive_y;

%remove every other row
A = A(1:2:end, :);

% add tikhonov smoothing
tik_block = spdiags( [-ones_cols ones_cols], [0 1], N, N); 
lambda = 10;
A = [A; lambda*tik_block];
b_pad = [b_vec; zeros(N, 1)];

%backslash
x_vec = A \ b_pad;

x = reshape(x_vec, sz_super);