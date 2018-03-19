function [y] = nng_ampscaled(coeffs, amp, T)

[t, r] = cart2pol(real(coeffs), imag(coeffs));
r_scaled = r ./ amp;
r_scaled = r;
r_thresh_scaled = ( r_scaled - T^2 ./ r_scaled ) .* (r_scaled > T); 
r_thresh = r_thresh_scaled .* amp;
[y_r, y_i] = pol2cart(t, r_thresh); 
y = y_r + 1i*y_i;
