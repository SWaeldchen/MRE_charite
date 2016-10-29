function slice_up = complex_slice_up_iter_gauss(slice, niter, target)

slice_r = real(slice);
slice_i = imag(slice);
slice_r_tv_den = iterative_increase_gauss(slice_r, niter, target);
slice_i_tv_den = iterative_increase_gauss(slice_i, niter, target);

slice_up = slice_r_tv_den + 1i*slice_i_tv_den;