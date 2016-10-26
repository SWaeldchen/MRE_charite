function x_ft = spectradb(x);

x_ft = log(normalizeImage(abs(fftshift(fft2(x))))) ./ log(10);
