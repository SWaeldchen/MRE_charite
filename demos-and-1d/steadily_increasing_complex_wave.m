function [x, pg] = steadily_increasing_complex_wave

x = zeros(64,1);
pg = zeros(size(x));
base_increment = pi/512;
x(1)= 1;
for n = 2:numel(x);
    increment = base_increment + (n/(pi*512));
	pg(n) = increment;
    prev = x(n-1);
    [t, ~] = cart2pol(real(prev), imag(prev));
    [a, b] = pol2cart(t+increment, 1);
    x(n) = a + 1i*b;
end


