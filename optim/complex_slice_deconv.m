function slice_tv = complex_slice_deconv(slice, psf, tviter, lambda, tau, epsilon)

slice_r = real(slice);
slice_i = imag(slice);
slice_r_tv_den = deconv_l2_pd(slice_r, tviter, lambda, tau, epsilon);
slice_i_tv_den = deconv_l2_pd(slice_i, tviter, lambda, tau, epsilon);

slice_tv = slice_r_tv_den + 1i*slice_i_tv_den;