function [x_nofilt, x_lap, x_g] = composite_wave_demo_pg_04(k_funcs, offset, b_f, a_f)

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
display_range = 513:2048-512;
xlims =  [0 1024];

h = figure(); 
set(gcf, 'position', [300 300 1200 1200']);
set(gcf, 'color', 'w');

ylims = [0 70];

subplot(7, 1, 1); 
complex_plot(steps(display_range)*1000, ['Orig K, mean: ', num2str(mean(steps(display_range))*1000)], 0, 1); 
ylim(ylims); 
xlim(xlims);

x(1) = 1; 
for n = 2:N;
      prev = x(n-1);
      [t, ~] = cart2pol(real(prev), imag(prev));
      [a, b] = pol2cart(t+steps(n), 1);
      x(n) = a + 1i*b;
end

subplot(7, 1, 2);
complex_plot(x(display_range), 'Orig Wave', 0, 1);
xlim(xlims);

x_lap = lap(x);
x_g = abs(x) ./ abs(x_lap);
x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));

subplot(7, 1, 3);
complex_plot(x_k_pg(display_range)*1000, [' d\phi K Recovery, mean: ' num2str(mean(x_k_pg(display_range))*1000)], 0, 1);
ylim(ylims);
xlim(xlims);

subplot(7, 1, 6);
complex_plot(x_k_lap(display_range)*1000, [' \nabla K Recovery, orig wave, mean: ' num2str(mean(x_k_lap(display_range))*1000)], 0, 1);
ylim(ylims);
 xlim(xlims);

if (nargin > 2)
	x = filter(b_f, a_f, x);
  %x = gradient(x);
  %x = conv(x, [-1 0 1], 'same');
  %x = x + y_cent;
end

subplot(7, 1, 4);
complex_plot(x(display_range), 'Low-Passed Wave', 0, 1, 0, 1);
 xlim(xlims);

x_lap = lap(x);
x_g = abs(x) ./ abs(x_lap);
x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));

subplot(7, 1, 5);
complex_plot(x_k_pg(display_range)*1000, ['Low Pass d\phi K Recovery, mean: ' num2str(mean(x_k_pg(display_range))*1000)], 0, 1);
ylim(ylims);
 xlim(xlims);

subplot(7, 1, 7);
complex_plot(x_k_lap(display_range)*1000, ['Low Pass \nabla K Recovery, mean: ' num2str(mean(x_k_lap(display_range))*1000)], 0, 1);
ylim(ylims);
 xlim(xlims);

end
