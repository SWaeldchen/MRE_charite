function y = logpwrspec(x)

y = log((abs(fftshift(fftn(x)))));