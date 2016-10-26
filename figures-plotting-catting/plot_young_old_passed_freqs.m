function plot_young_old_passed_freqs(naive, sr)

figure();
set(gcf, 'color', 'white');
set(gcf, 'position', [600 600 900 450]);
plot(1:10, naive*100, 'color', 'black', 'linestyle', '-');
hold on;
plot(1:10, sr*100, 'color', 'black', 'linestyle', '--');
xlabel('Subject');
ylabel('%');
leg = legend({'$|G^{*}|_{NAIVE}$', '$|G^{*}|_{SR}$'}, 'Interpreter', 'LaTeX', 'fontsize', 18);
title('Passed frequencies as a $\%$ of total spectrum, $|G^{*}|_{NAIVE}$ and $|G^{*}|_{SR}$', 'interpreter', 'latex', 'fontsize', 18, 'fontweight', 'bold');
