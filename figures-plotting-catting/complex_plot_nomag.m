function complex_plot_nomag(x, title_, n, no_new_fig, xrange, isoctave, gray)


if size(x, 1) == 1
	x = permute(x, [2 1]);
end

if nargin < 6
	isoctave = 0;
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
if nargin < 5 || xrange == 0
	xrange = 1:n;
end
if (no_new_fig == 0)
	figure();
end
if (isreal(x))
  if (nargin > 6) && gray > 0
     color = [0.8 0.8 0.8];
  else 
     color = [0 0 0];
  end
  plot(xrange, x(1:n,:), 'color', color, 'Linewidth', 2);
else
  a = real(x);
  b = imag(x);
  %c = abs(x);
  plot(xrange, a(1:n, :), 'b');
  hold on;
  plot(xrange, b(1:n, :), 'r--');
  %plot(xrange, c(1:n, :), 'k', 'LineWidth', 2);
end
if isoctave
	title(title_, 'Interpreter', 'tex', 'FontSize', 18);
else 
	title(title_, 'Interpreter', 'tex', 'FontSize', 18);
end
hold off;
