function slice_den = brain_slice_tv_den(slice, niter, lambda, tau, epsilon)

slice_r = real(slice);
slice_i = imag(slice);
slice_r_tv_den = eb_gd_tv(slice_r, niter, lambda, tau, epsilon);
slice_i_tv_den = eb_gd_tv(slice_i, niter, lambda, tau, epsilon);

slice_den = slice_r_tv_den + 1i*slice_i_tv_den;

