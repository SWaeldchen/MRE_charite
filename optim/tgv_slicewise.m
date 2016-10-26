function x_tgv = tgv_slicewise(x)

% x must be 3d or higher
sz = size(x);
remaining_dims = sz(4:end);
new_dim3 = sz(3)*prod(remaining_dims);
x_resh = reshape(x, [size(x, 1), size(x, 2), new_dim3]);

est_mean = mean(vec(middle_square(x(:,:,1))));

L1 = 0.0028 * est_mean;
L0 = 0.005 * est_mean;
niter = 100;

for n = 1:new_dim3
    x_resh(:,:,n) = tgv_pd(x_resh(:,:,n), L1, L0, niter, niter);
end

x_tgv = reshape(x_resh, sz);