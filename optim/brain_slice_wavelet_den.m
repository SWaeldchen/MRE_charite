function slice_den = brain_slice_wavelet_den(slice, spins, T, J)

slice_r = real(slice);
slice_i = imag(slice);
slice_r_tv_den = DT_2D_spin(slice_r, spins, T, J);
slice_i_tv_den = DT_2D_spin(slice_i, spins, T, J);

slice_den = slice_r_tv_den + 1i*slice_i_tv_den;

