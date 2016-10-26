function complexPlot(x, title_, n, no_new_fig, xrange)

if nargin < 4
	no_new_fig = 0;
	if nargin < 3
		n = size(x, 1); 
		if nargin < 2
			title_ = '';
		end
	end
end
if n == 0
	n = size(x, 1);
end
if nargin < 5
	xrange = 1:n;
end
a = real(x);
b = imag(x);
c = abs(x);
if (no_new_fig == 0)
	figure();
end
plot(xrange, a(1:n, :), 'b');
hold on;
plot(xrange, b(1:n, :), 'r');
plot(xrange, c(1:n, :), 'k', 'LineWidth', 2);
title(title_);
hold off;
