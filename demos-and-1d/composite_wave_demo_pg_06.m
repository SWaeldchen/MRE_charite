function [x_nofilt, x_lap, x_g] = composite_wave_demo_pg_06(k_func, magvector, b_f, a_f)

  %% Generate elasticity fields
% Generate base waves
N = numel(k_func);
x = zeros(N, 1);
steps = k_func;
display_span = 1200;
% CONTROL FOR BUTTERWORTH NONLINEAR PHASE SHIFT
display_range1 = 450:450+display_span;
display_range2 = 650:650+(display_span);
xlims =  [1 numel(display_range1)];

h = figure(); 
set(gcf, 'position', [300 300 1200 1200']);
set(gcf, 'color', 'w');

ylims = [4000 16000];

subplot(4, 2, 1); 
complex_plot(steps(display_range1), ['Wavenumber Vector'], 0, 1); 
%ylim(ylims); 
xlim(xlims);
ylabel('Wavenumber');

subplot(4, 2, 2); 
complex_plot(magvector(display_range1), ['Magnitude Vector'], 0, 1); 
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

subplot(4, 2, 3);
complex_plot(x(display_range1), 'Orig Wave', 0, 1);
xlim(xlims);
ylabel('Phase (rad)');
 ylim([-1 1.1]);

x_lap = lap(x);
%x_g = abs(x) ./ abs(x_lap);
x_g = medfilt1( abs(x) ./ abs(x_lap), 17);
%x_g = convn(x_g, fspecial('gaussian', [63 1], 27), 'same');

x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));
x_g_pg = 1 ./ x_k_pg.^2;

subplot(4, 2, 5);
complex_plot( x_g_pg(display_range1), [' d\phi |G*| Recovery, mean: ' num2str(round(mean(x_g_pg(display_range1))))], 0, 1);
ylim(ylims);
xlim(xlims);
ylabel('Pascals');

subplot(4, 2, 7);
complex_plot(  x_g(display_range1), [' \nabla |G*| Recovery, mean: ' num2str(round(mean(x_g(display_range1))))], 0, 1);
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

subplot(4, 2, 4);
complex_plot(x(display_range2), 'Low-Passed Wave', 0, 1, 0, 1);
 xlim(xlims);
 ylabel('Phase (rad)');
 ylim([-1 1.1]);


x_lap = lap(x);
x_g_lp = abs(x) ./ abs(x_lap);
x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));
x_g_pg_lp = 1 ./ x_k_pg.^2;


subplot(4, 2, 6);
complex_plot( x_g_pg_lp(display_range2), [' Low Pass d\phi |G*| Recovery, mean: ' num2str(round(mean(x_g_pg_lp(display_range2))))], 0, 1);
 ylim(ylims);
 xlim(xlims);
 ylabel('Pascals');



subplot(4, 2, 8);
complex_plot( x_g_lp(display_range2), ['Low Pass \nabla |G*| Recovery, mean: ' num2str(round(mean(x_g_lp(display_range2))))], 0, 1);
 ylim(ylims);
 xlim(xlims);
 ylabel('Pascals');

 diff = mean(x_g(display_range1)) - mean(x_g_lp(display_range2))

 
end

