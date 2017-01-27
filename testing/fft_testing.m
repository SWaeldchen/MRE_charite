a = zeros(64, 1);

figure(1)
for n = 1:8
    aa = a;
    aa(n) = 1;
    subplot(8, 1, n); complex_plot(ifft(aa), '', 0, 1);
end
title('FFT');

figure(2)
for n = 1:8
    aa = a;
    aa(n) = 1;
    subplot(8, 1, n); complex_plot(idct(aa), '', 0, 1);
end
title('DCT');