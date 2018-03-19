%demo script to view spectra of CDTW components

v = double(imread('lena.tif')); % standard image
[Faf, ~] = FSfarras;
[af, ~] = dualfilt1;
ws = cdtw_2d_stationary(v, 3, Faf, af);

cplx11 = ws{1}{1}{1}{1} + 1i*ws{1}{2}{1}{1};
cplx12 = ws{1}{1}{1}{2} + 1i*ws{1}{2}{1}{2};
cplx13 = ws{1}{1}{1}{3} + 1i*ws{1}{2}{1}{3};
cplx21 = ws{1}{1}{2}{1} + 1i*ws{1}{2}{2}{1};
cplx22 = ws{1}{1}{2}{2} + 1i*ws{1}{2}{2}{2};
cplx23 = ws{1}{1}{2}{3} + 1i*ws{1}{2}{2}{3};
%%
cplx11_spectrum = abs(fftshift(fft2(cplx11)));
cplx12_spectrum = abs(fftshift(fft2(cplx12)));
cplx13_spectrum = abs(fftshift(fft2(cplx13)));
cplx21_spectrum = abs(fftshift(fft2(cplx21)));
cplx22_spectrum = abs(fftshift(fft2(cplx22)));
cplx23_spectrum = abs(fftshift(fft2(cplx23)));

montage1 = cat(2, cplx11_spectrum, cplx12_spectrum, cplx13_spectrum);
montage2 = cat(2, cplx21_spectrum, cplx22_spectrum, cplx23_spectrum);
spectrum_montage = cat(1, montage1, montage2);
figure(); subplot(3, 2, 1); imagesc(spectrum_montage);

montage1 = cat(2, abs(cplx11), abs(cplx12), abs(cplx13));
montage2 = cat(2, abs(cplx21), abs(cplx22), abs(cplx23));
image_montage = cat(1, montage1, montage2);
subplot(3, 2, 2); imagesc(image_montage);
%%
cplx11 = ws{2}{1}{1}{1} + 1i*ws{2}{2}{1}{1};
cplx12 = ws{2}{1}{1}{2} + 1i*ws{2}{2}{1}{2};
cplx13 = ws{2}{1}{1}{3} + 1i*ws{2}{2}{1}{3};
cplx21 = ws{2}{1}{2}{1} + 1i*ws{2}{2}{2}{1};
cplx22 = ws{2}{1}{2}{2} + 1i*ws{2}{2}{2}{2};
cplx23 = ws{2}{1}{2}{3} + 1i*ws{2}{2}{2}{3};

cplx11_spectrum = abs(fftshift(fft2(cplx11)));
cplx12_spectrum = abs(fftshift(fft2(cplx12)));
cplx13_spectrum = abs(fftshift(fft2(cplx13)));
cplx21_spectrum = abs(fftshift(fft2(cplx21)));
cplx22_spectrum = abs(fftshift(fft2(cplx22)));
cplx23_spectrum = abs(fftshift(fft2(cplx23)));

montage1 = cat(2, cplx11_spectrum, cplx12_spectrum, cplx13_spectrum);
montage2 = cat(2, cplx21_spectrum, cplx22_spectrum, cplx23_spectrum);
spectrum_montage = cat(1, montage1, montage2);
subplot(3, 2, 3); imagesc(spectrum_montage);

montage1 = cat(2, abs(cplx11), abs(cplx12), abs(cplx13));
montage2 = cat(2, abs(cplx21), abs(cplx22), abs(cplx23));
image_montage = cat(1, montage1, montage2);
subplot(3, 2, 4); imagesc(image_montage);

%%

cplx11 = ws{3}{1}{1}{1} + 1i*ws{3}{2}{1}{1};
cplx12 = ws{3}{1}{1}{2} + 1i*ws{3}{2}{1}{2};
cplx13 = ws{3}{1}{1}{3} + 1i*ws{3}{2}{1}{3};
cplx21 = ws{3}{1}{2}{1} + 1i*ws{3}{2}{2}{1};
cplx22 = ws{3}{1}{2}{2} + 1i*ws{3}{2}{2}{2};
cplx23 = ws{3}{1}{2}{3} + 1i*ws{3}{2}{2}{3};

cplx11_spectrum = abs(fftshift(fft2(cplx11)));
cplx12_spectrum = abs(fftshift(fft2(cplx12)));
cplx13_spectrum = abs(fftshift(fft2(cplx13)));
cplx21_spectrum = abs(fftshift(fft2(cplx21)));
cplx22_spectrum = abs(fftshift(fft2(cplx22)));
cplx23_spectrum = abs(fftshift(fft2(cplx23)));

montage1 = cat(2, cplx11_spectrum, cplx12_spectrum, cplx13_spectrum);
montage2 = cat(2, cplx21_spectrum, cplx22_spectrum, cplx23_spectrum);
spectrum_montage = cat(1, montage1, montage2);
subplot(3, 2, 5); imagesc(spectrum_montage);

montage1 = cat(2, abs(cplx11), abs(cplx12), abs(cplx13));
montage2 = cat(2, abs(cplx21), abs(cplx22), abs(cplx23));
image_montage = cat(1, montage1, montage2);
subplot(3, 2, 6); imagesc(image_montage);