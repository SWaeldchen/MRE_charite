function plot_valid_lap(x, t);

y = conv(x, [1 -2 1], 'valid');
complexPlot(y, t);