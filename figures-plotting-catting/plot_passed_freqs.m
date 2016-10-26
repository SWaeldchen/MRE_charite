function plot_passed_freqs(passed_freqs_naive, passed_freqs_sr)

figure();
set(gcf, 'color', 'white');
set(gcf, 'position', [600 600 900 450]);
plot(1:10, passed_freqs_naive, 'color', 'black', 'linestyle', '-');
hold on;
plot(1:10, passed_freqs_sr, 'color', 'black', 'linestyle', '--');
xlabel('Subject');
ylabel('Num. Passed Frequencies');
leg = legend({'$|G^{*}|_{NAIVE}$', '$|G^{*}|_{SR}$'}, 'Interpreter', 'LaTeX', 'fontsize', 18);
title('Number of Passband Frequencies, $|G^{*}|_{NAIVE}$ and $|G^{*}|_{SR}$', 'interpreter', 'latex', 'fontsize', 18, 'fontweight', 'bold');
