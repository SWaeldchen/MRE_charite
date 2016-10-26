%demo script to view spectra of CDTW components

v = double(imread('lena.tif')); % standard image
[Faf, ~] = FSfarras;
[af, ~] = dualfilt1;
w = cplxdual2D(v, 2, Faf, af);

cplx11 = w{2}{1}{1}{1} + 1i*w{2}{2}{1}{1};
cplx12 = w{2}{1}{1}{2} + 1i*w{2}{2}{1}{2};
cplx13 = w{2}{1}{1}{3} + 1i*w{2}{2}{1}{3};
cplx21 = w{2}{1}{2}{1} + 1i*w{2}{2}{2}{1};
cplx22 = w{2}{1}{2}{2} + 1i*w{2}{2}{2}{2};
cplx23 = w{2}{1}{2}{3} + 1i*w{2}{2}{2}{3};

cplx11_spectrum = abs(fftshift(fft2(cplx11)));
cplx12_spectrum = abs(fftshift(fft2(cplx12)));
cplx13_spectrum = abs(fftshift(fft2(cplx13)));
cplx21_spectrum = abs(fftshift(fft2(cplx21)));
cplx22_spectrum = abs(fftshift(fft2(cplx22)));
cplx23_spectrum = abs(fftshift(fft2(cplx23)));

montage1 = cat(2, cplx11_spectrum, cplx12_spectrum, cplx13_spectrum);
montage2 = cat(2, cplx21_spectrum, cplx22_spectrum, cplx23_spectrum);
montage = cat(1, montage1, montage2);
imagesc(montage);