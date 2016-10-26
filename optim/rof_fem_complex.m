function x_rof = rof_fem_complex(x, lambda, niter, check)

x_r = real(x);
x_i = imag(x);
x_r_rof = rof_moreau_agd(x_r, lambda, niter, check);
x_i_rof = rof_moreau_agd(x_i, lambda, niter, check);

x_rof = x_r_rof + 1i*x_i_rof;
