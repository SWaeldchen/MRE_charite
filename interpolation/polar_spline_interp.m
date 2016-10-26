function y = polar_spline_interp(x, fac)
x_re = real(x);
x_im = imag(x);
[t, r] = cart2pol(x_re, x_im);
t = exp(-1i.*t);
t_re = real(t);
t_im = imag(t);
r = spline_interp(spline_interp(r, fac)', fac)';
t_re = spline_interp(spline_interp(t_re, fac)', fac)';
t_im = spline_interp(spline_interp(t_im, fac)', fac)';
t = angle(t_re + 1i*t_im);
[y_re, y_im] = pol2cart(t, r);
y = y_re + 1i*y_im;

