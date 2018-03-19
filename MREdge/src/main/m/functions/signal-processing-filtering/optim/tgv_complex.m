function x_tgv = tgv_complex(x, lam_1, lam_0, max_iter, check)

x_r = real(x);
x_i = imag(x);

x_r_tgv = tgv_pd(x_r, lam_1, lam_0, max_iter, check);
x_i_tgv = tgv_pd(x_i, lam_1, lam_0, max_iter, check);

x_tgv = x_r_tgv + 1i*x_i_tgv;

