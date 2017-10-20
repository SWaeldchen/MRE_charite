function y = pwrspec(x)

y = abs(fftshift(fftn(x)));