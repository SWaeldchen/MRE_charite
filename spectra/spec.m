function y = spec(x)

y = log(normalizeImage(abs(fftshift(fft2(x)))));