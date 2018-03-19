function x_tv = smooth_tv_complex(x, niter, lam, tau, eta)

x_r = real(x);
x_i = imag(x);

x_r_tv = eb_gd_tv(x_r, niter, lam, tau, eta);
x_i_tv = eb_gd_tv(x_i, niter, lam, tau, eta);

x_tv = x_r_tv + 1i*x_i_tv;