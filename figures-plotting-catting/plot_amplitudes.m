figure();
set(gcf, 'Color', 'w');
plot(meanstack, 'LineWidth', 3); hold on;
set(gca, 'XTickLabel', {'0.5V', '0.7V', '1V', '0.5V', '0.7V', '1V', '0.5V', ...
    '0.7V', '1V'}); 
whites = zeros(size(meanstack));
whites([3:4, 6:7], :) = meanstack([3:4, 6:7], :);
whitemask = find(whites == 0);
whites(whitemask) = nan;
plot(whites, 'w', 'LineWidth', 3);
legend('Wavelet / OGS / PCA', 'No Denoise', 'Lowpass 100 w/m', 'Lowpass 50 w/m', 'Lowpass 25 w/m');
ylim([500 5000]);