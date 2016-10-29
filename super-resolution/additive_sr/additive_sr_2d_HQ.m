function x = additive_sr_2d_HQ(b, super_factor)

sz = size(b);
b_vec = double(b(:));
sz_super = [sz(1)*super_factor 1];

% make bands
y_diags = 1:1:super_factor-1;
x_diags = 

% the matrix is first built to SR dimensions, then columns are removed
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

% HQ optimization

% set params
x0 = zeros(size(b_vec)*super_factor);
y = b_vec;
phi = 'hub';
a = 0.01;
b = 0.01;
dJ=1e-5*norm(y)/length(y);  
MxIt = 100;


[x_vec,it,Co,J,dx]=HQAd1d(x0,y,A,phi,a,b,0,dJ,MxIt);

x = reshape(x_vec, sz_super);
