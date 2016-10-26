function [x_nofilt, x_lap, x_g] = composite_wave_demo_pg(k_funcs, offset, b_f, a_f)

  %% Generate elasticity fields
% Generate base waves

if iscell(k_funcs)
  N = numel(k_funcs{1});
else
  N = numel(k_funcs);
end
x = zeros(N, 1);
steps = zeros(N, 1);

for n = 1:numel(k_funcs)
  if iscell(k_funcs)
    steps = steps + k_funcs{n};
  else
    steps = steps + k_funcs;
  end
end
display_range = 513:2048+512;

h = figure(); 
set(gcf, 'position', [300 300 1200 1200']);
set(gcf, 'color', 'w');

ylims = [offset-.02 offset+.02];

subplot(2, 2, 1); 

steps = steps + offset;
complex_plot(steps(display_range), 'K', 0, 1); 
ylim(ylims);



x(1) = 1; 
for n = 2:N;
      prev = x(n-1);
      [t, ~] = cart2pol(real(prev), imag(prev));
      [a, b] = pol2cart(t+steps(n), 1);
      x(n) = a + 1i*b;
end

x_nofilt = x;

if (nargin > 2)
	x = filter(b_f, a_f, x);
  %x = gradient(x);
  %x = conv(x, [-1 0 1], 'same');
  %x = x + y_cent;
end

subplot(2, 2, 2);
complex_plot(x(display_range), 'Wave', 0, 1);

x = x+offset;

x_lap = lap(x);
x_g = abs(x) ./ abs(x_lap);
x_k = sqrt(-lap(x)./x);
x_k_2 = gradient(unwrap(angle(x)));

subplot(2, 2, 3);
complex_plot(x_lap(display_range), 'Laplacian', 0, 1);
subplot(2, 2, 4);
complex_plot(x_k(display_range), 'K Recovery', 0, 1); 
hold on;
complex_plot(steps(display_range), '', 0, 1, 0, 1, 1);
ylim(ylims);

end
