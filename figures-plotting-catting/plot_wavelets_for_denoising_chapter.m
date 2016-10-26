waves1 = sinVec(256, 64);
waves2 = sinVec(256, 64, 3*pi/4);
waves = cat(2, waves1, waves2);%, waves1, waves2);
waves = waves + 0.05*randn(size(waves));
waves_FT = fft(waves);
[Faf, Fsf] = FSfarras; [af, sf] = dualfilt1;
w = dualtree(waves, 3, Faf, af);
w_lo = w{4}{1} + 1i*w{4}{2};
w_1 = w{1}{1} + 1i*w{1}{2};
w_2 = w{2}{1} + 1i*w{2}{2};
w_3 = w{3}{1} + 1i*w{3}{2};

a = figure(); set(a, 'Color', 'white');
subplot(8, 1, 1); hold on; plot(waves, 'k', 'LineWidth', 2); xlim([1 512]); title('Single frequency wave with discontinuity and 5% Noise');
subplot(8, 1, 2); hold on; 
    plot(real(waves_FT), 'r', 'LineWidth', 1); 
    plot(imag(waves_FT), 'b', 'LineWidth', 1); 
    plot(abs(waves_FT), 'g', 'LineWidth', 1); 
    xlim([1 256]); title('Fourier Transform (First Half)');
subplot(8, 1, 3); hold on; 
    plot(real(w_1), 'r', 'LineWidth', 1); 
    plot(imag(w_1), 'b', 'LineWidth', 1);
    plot(abs(w_1), 'g', 'LineWidth', 1);
    xlim([1 256]); title('MRA, Wavelet Level 1');
subplot(8, 1, 4); hold on;
    plot(real(w_2), 'r', 'LineWidth', 1);
    plot(imag(w_2), 'b', 'LineWidth', 1);
    plot(abs(w_2), 'g', 'LineWidth', 1);
    xlim([1 128]); title('MRA, Wavelet Level 2');
subplot(8, 1, 5); hold on;
    plot(real(w_3), 'r', 'Linewidth', 1);
    plot(imag(w_3), 'b', 'LineWidth', 1);
    plot(abs(w_3), 'g', 'LineWidth', 1);
    xlim([1 64]); title('MRA, Wavelet Level 3');
subplot(8, 1, 6); hold on;
    plot(real(w_lo), 'r', 'Linewidth', 1);
    plot(imag(w_lo), 'b', 'LineWidth', 1);
    plot(abs(w_lo), 'g', 'LineWidth', 1);
    xlim([1 64]); title('MRA, Scaling');

thresh = 0.12
w_1_thresh = find(abs(w_1) < thresh);
w{1}{1}(w_1_thresh) = 0; w{1}{2}(w_1_thresh) = 0;
w_2_thresh = find(abs(w_2) < thresh);
w{2}{1}(w_2_thresh) = 0; w{2}{2}(w_2_thresh) = 0;
w_3_thresh = find(abs(w_3) < thresh);
w{3}{1}(w_3_thresh) = 0; w{3}{2}(w_3_thresh) = 0;
waves_hardthresh = idualtree(w, 3, Fsf, sf);

[b, a] = butter(4, 0.2);
waves_lopass = filter(b, a, waves);

subplot(8, 1, 7); hold on; plot(waves_lopass, 'k', 'LineWidth', 2); xlim([1 512]); title('Denoised Waves, Fourier Domain (Butterworth)');
subplot(8, 1, 8); hold on; plot(waves_hardthresh, 'k', 'LineWidth', 2); xlim([1 512]); title('Denoised Waves, Wavelet Domain (Hard Threshold)');
