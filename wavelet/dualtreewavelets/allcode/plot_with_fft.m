function plot_with_fft(x)
sz = size(x);
figure(); hold on;
for n = 1:sz(1)
    display((n-0)*2+1)
    subplot(sz(1)*2, 1, (n-1)*2+1); 
    plot (x(n,:), 'b'); xlim([1,512]);
    subplot(sz(1)*2, 1, (n-1)*2+2);
    ft = fft(x(n,:));
    hold on; plot(real(ft), 'b', 'LineWidth', 2); 
    plot(imag(ft), 'g', 'Linewidth', 2); 
    plot(abs(ft), 'r', 'LineWidth', 1);
    xlim([1,128]);
    hold off;
end