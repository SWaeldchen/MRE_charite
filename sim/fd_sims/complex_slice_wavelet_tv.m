function slice_tv = complex_slice_wavelet_tv(slice, tviter, lambda, tau, epsilon)

slice_r = real(slice);
slice_i = imag(slice);
slice_r_tv_den = eb_gd_tv_wavelet(slice_r, tviter, lambda, tau, epsilon);
slice_i_tv_den = eb_gd_tv_wavelet(slice_i, tviter, lambda, tau, epsilon);

slice_tv = slice_r_tv_den + 1i*slice_i_tv_den;