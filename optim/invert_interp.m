function slice_sr = invert_interp(slice, niter, lambda, tau, superfac, mode, swap, epsilon)

slice_sr_r = eb_gd_sup_cubic_interp(real(slice), niter, lambda, tau, superfac, mode, swap, epsilon);
slice_sr_i = eb_gd_sup_cubic_interp(imag(slice), niter, lambda, tau, superfac, mode, swap, epsilon);

slice_sr = slice_sr_r + 1i*slice_sr_i;

quick_invert(slice_sr);