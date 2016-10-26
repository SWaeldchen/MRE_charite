function y = polar_wavelet_interp(x, fac)
x_re = real(x);
x_im = imag(x);
[t, r] = cart2pol(x_re, x_im);
t = exp(-1i.*t);
t_re = real(t);
t_im = imag(t);
r = cdwt_interp_2d(r, fac);
t_re = cdwt_interp_2d(t_re, fac);
t_im = cdwt_interp_2d(t_im, fac);
t = angle(t_re + 1i*t_im);
[y_re, y_im] = pol2cart(t, r);
y = y_re + 1i*y_im;

