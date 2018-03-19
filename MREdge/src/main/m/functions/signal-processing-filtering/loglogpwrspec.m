function y = loglogpwrspec(x)

y = log(log((abs(fftshift(fftn(x))))));