function slice_up = complex_slice_up_iter(slice, niter, target, tviter, lambda, tau, epsilon)

slice_r = real(slice);
slice_i = imag(slice);
slice_r_tv_den = iterative_increase_smtv_bicubic(slice_r, niter, target, tviter, lambda, tau, epsilon);
slice_i_tv_den = iterative_increase_smtv_bicubic(slice_i, niter, target, tviter, lambda, tau, epsilon);

slice_up = slice_r_tv_den + 1i*slice_i_tv_den;