function [x_nofilt, x_lap, x_g] = composite_wave_demo_pg_05(k_func, magvector, b_f, a_f)

  %% Generate elasticity fields
% Generate base waves
N = numel(k_func);
x = zeros(N, 1);
steps = k_func;
%display_range = 513:2048-512;
display_range = 513:2048-512;
xlims =  [1 numel(display_range)];

h = figure(); 
set(gcf, 'position', [300 300 1200 1200']);
set(gcf, 'color', 'w');

ylims = [0 20000];

subplot(6, 1, 1); 
complex_plot(steps(display_range)*1000, ['Wavenumber Vector'], 0, 1); 
%ylim(ylims); 
xlim(xlims);
ylabel('Wavenumber');

subplot(6, 1, 2); 
complex_plot(magvector(display_range), ['Magnitude Vector'], 0, 1); 
%ylim(ylims); 
xlim(xlims);
ylabel('Magnitude');


x(1) = 1; 
for n = 2:N;
      prev = x(n-1);
      [t, ~] = cart2pol(real(prev), imag(prev));
      [a, b] = pol2cart(t+steps(n), magvector(n));
      x(n) = a + 1i*b;
end

subplot(6, 1, 3);
complex_plot(x(display_range), 'Wave', 0, 1);
xlim(xlims);
ylabel('Phase (rad)');

x_lap = lap(x);
x_g = abs(x) ./ abs(x_lap);
%x_g = medfilt1( abs(x) ./ abs(x_lap), 17);

x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));
x_g_pg = 1 ./ x_k_pg;

subplot(6, 1, 4);
complex_plot(  x_g(display_range), [' \nabla |G*| Recovery, mean: ' num2str(mean(x_g(display_range)))], 0, 1);
ylim(ylims);
xlim(xlims);
ylabel('Pascals');

if (nargin > 2)
	x = filter(b_f, a_f, x);
  %x = conv(x, fspecial('gaussian', [251 1], 77), 'same');
    %x = conv(x, ones(512,1)/512, 'same');
%x = gradient(x);
  %x = conv(x, [-1 0 1], 'same');
  %x = x + y_cent;
end

subplot(6, 1, 5);
complex_plot(x(display_range), 'Low-Passed Wave', 0, 1, 0, 1);
 xlim(xlims);
 ylabel('Phase (rad)');


x_lap = lap(x);
x_g = abs(x) ./ abs(x_lap);
x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));
x_g_pg_lp = 1 ./ x_k_pg;

subplot(6, 1, 6);
complex_plot( x_g(display_range), ['Low Pass \nabla |G*| Recovery, mean: ' num2str(mean(x_g(display_range)))], 0, 1);
 ylim(ylims);
 xlim(xlims);
 ylabel('Pascals');


end
