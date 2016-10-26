
h = figure();
set(h, 'Position', [660 490 940 640]);
set(h, 'color', 'white');
c = colormap(jet(7));
c = c(1:3:end,:);
n_s = size(f,1);
subplot(2, 1, 1);
hold on;
plot(1:n_s, f(:,1), 'Color', c(1,:), 'LineWidth', 2);
plot(1:n_s, f(:,2), 'Color', c(2,:), 'LineWidth', 2);
plot(1:n_s, f(:,3), 'Color', c(3,:), 'LineWidth', 2);
legend('1x', '2x', '4x');
xlim([1 n_s]);
title('Num. Passed Frequencies, Brain', 'Interpreter', 'LaTeX', 'FontSize', 18);


n_s = size(e,1);
subplot(2, 1, 2);
hold on;
plot(1:n_s, e(:,1), 'Color', c(1,:), 'LineWidth', 2);
plot(1:n_s, e(:,2), 'Color', c(2,:), 'LineWidth', 2);
plot(1:n_s, e(:,3), 'Color', c(3,:), 'LineWidth', 2);
legend('1x', '2x', '4x');
xlim([1 n_s]);
title('Total Energy of Passed Frequencies, Brain', 'Interpreter', 'LaTeX', 'FontSize', 18);