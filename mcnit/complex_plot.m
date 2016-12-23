function complex_plot(x, title_, n, no_new_fig, xrange, gray)


if size(x, 1) == 1
	x = permute(x, [2 1]);
end

if nargin < 6
	gray = 0;
	if nargin < 4
		no_new_fig = 0;
		if nargin < 3
			n = size(x, 1); 
			if nargin < 2
				title_ = '';
			end
		end
	end
end


if n == 0
	n = size(x, 1);
end
if (nargin < 5) || (numel(xrange) == 1 && xrange == 0);
	xrange = 1:n;
end
if (no_new_fig == 0)
	figure();
end
if gray > 0
 c1 = [0.8 0.8 0.8];
 c2 = [0.5 0.5 0.5];
 c3 = [0 0 0];
else 
 c1 = [1 0 0];
 c2 = [0 0 1];
 c3 = [0 0 0];
end
if (isreal(x))
  plot(xrange, x(1:n,:), 'color', c3, 'Linewidth', 2);
else
  a = real(x);
  b = imag(x);
  c = abs(x);
  plot(xrange, a(1:n, :), 'color', c1);
  hold on;
  plot(xrange, b(1:n, :), 'color', c2);
  plot(xrange, c(1:n, :), 'color', c3, 'LineWidth', 2);
end
if isoctave()
	title(title_, 'Interpreter', 'tex', 'FontSize', 18);
else 
	title(title_, 'Interpreter', 'latex', 'FontSize', 18);
end
hold off;
