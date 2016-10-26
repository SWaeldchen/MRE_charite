function x = additive_sr_backslash_1d_tikhonov(b, super_factor, lambda)

sz = size(b);
b_vec = double(b(:));
sz_super = [sz(1)*super_factor 1];

% make bands - only 1 for 1D
y_diags = 1:1:super_factor-1;

% the matrix is fist built to SR dimensions, then columns are removed
N = prod(sz_super);
ones_cols = ones(N, numel(y_diags));

% identity matrix, SR dimensions
I = speye(N);

% make additive matrix, SR dimensions
additive_y = spdiags(ones_cols, y_diags, N, N);

A = I + additive_y;

%remove overlapping rows. Now each LR pixel is a sum of super_factor
% unique number of pixels in the SR image.
A = A(1:super_factor:end, :);

% add tikhonov smoothing
tik_block = spdiags( [-ones_cols 2*ones_cols -ones_cols], [-1 0 1], N, N); 
A = [A; lambda*tik_block];
b_pad = [b_vec; zeros(N, 1)];

%backslash
x_vec = A \ b_pad;

x = reshape(x_vec, sz_super);