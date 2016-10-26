function x_sr = gd_sr_complex(x, niter, lambda, epsilon, tau, superfac, swap)

display('Real')
tic
x_sr_r = eb_gd_sup_exp(real(x), niter, lambda, tau, superfac, 'L1', swap, epsilon);
toc
display('Imaginary');
tic
x_sr_i = eb_gd_sup_exp(imag(x), niter, lambda, tau, superfac, 'L1', swap, epsilon);
toc
x_sr = x_sr_r + x_sr_i;