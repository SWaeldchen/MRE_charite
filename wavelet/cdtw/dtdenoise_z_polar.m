function x_den = dtdenoise_z_polar(x, mag_fac, phase_fac)

[x_t, x_r] = cart2pol(real(x), imag(x));
x_r_den = dtdenoise_z(x_r, mag_fac);
x_t_den = dtdenoise_z(x_t, phase_fac);

x_den = pol2cart(x_t_den, x_r_den);
