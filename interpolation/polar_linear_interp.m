function y = polar_linear_interp(x, fac)
x_re = real(x);
x_im = imag(x);
[t, r] = cart2pol(x_re, x_im);
t = exp(-1i.*t);
t_re = real(t);
t_im = imag(t);
r = linear_interp(linear_interp(r, fac)', fac)';
t_re = linear_interp(linear_interp(t_re, fac)', fac)';
t_im = linear_interp(linear_interp(t_im, fac)', fac)';
t = angle(t_re + 1i*t_im);
[y_re, y_im] = pol2cart(t, r);
y = y_re + 1i*y_im;

