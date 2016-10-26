function y = normlogpwrspec(x)

x_ft = abs(fftshift(fftn(x)));
y = log(normalizeImage(x_ft)) ./ log(10);