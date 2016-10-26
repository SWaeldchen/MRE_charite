function x_tgv = tv_slicewise(x)

% x must be 3d or higher
sz = size(x);
remaining_dims = sz(4:end);
new_dim3 = sz(3)*prod(remaining_dims);
x_resh = reshape(x, [size(x, 1), size(x, 2), new_dim3]);

est_mean = mean(vec(middle_square(x(:,:,1))));

lam = 0.01 * est_mean;
eps = 0.02 * est_mean;
niter = 1000;

for n = 1:new_dim3
    x_resh(:,:,n) = smooth_tv_complex(x_resh(:,:,n), lam, eps, niter);
end

x_tgv = reshape(x_resh, sz);