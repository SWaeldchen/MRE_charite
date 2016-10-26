function [y] = slicewise_spectra(x)
x = squeeze(x);
for n = 1:size(x,3)
    y(:,:,n) = log(abs(fftshift(fft2(normalizeImage(x(:,:,n))))).^2);
end