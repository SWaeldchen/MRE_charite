function plot_young_old_mean_stiffness(means1x, means4x)

figure();
or = cat(1, means1x(:,1), means1x(:,2));
sr = cat(1, means4x(:,1), means4x(:,2)); 
set(gcf, 'color', 'white');
set(gcf, 'position', [600 600 900 450]);
plot(1:10, or, 'color', 'black', 'linestyle', '-');
hold on;
plot(1:10, sr, 'color', 'black', 'linestyle', '--');
xlabel('Subject');
ylabel('|G^{*}|');
leg = legend({'$|G^{*}|$', '$|G^{*}|_{SR}$'}, 'Interpreter', 'LaTeX', 'fontsize', 18);
title('Mean Stiffness, $|G^{*}|$ and $|G^{*}|_{SR}$', 'interpreter', 'latex', 'fontsize', 18, 'fontweight', 'bold');
ylim([0 2000]);
