function [diff] = ieee_undershoot_wave_generation(k_func, magvector, b_f, a_f, plots)

  %% Generate elasticity fields
% Generate base waves
N = numel(k_func);
x = zeros(N, 1);
steps = k_func;
display_span = 600;
% CONTROL FOR BUTTERWORTH NONLINEAR PHASE SHIFT
nonlin_shift = 0;
display_range1 = round(N/4):round(N/4)+display_span;
display_range2 = round(N/4) + nonlin_shift : round(N/4)+ nonlin_shift + display_span;
xlims =  [1 numel(display_range1)];

x(1) = 1; 
for n = 2:N;
      prev = x(n-1);
      [t, ~] = cart2pol(real(prev), imag(prev));
      [a, b] = pol2cart(t+steps(n), magvector(n));
      x(n) = a + 1i*b;
end


if plots > 0
  figure(); 
  set(gcf, 'position', [300 300 1200 300']);
  set(gcf, 'color', 'w');

  ylims = [0 20000];

  subplot(2, 3, 1); 
  complex_plot(x(display_range1), 'Orig Wave', 0, 1);
  xlim(xlims);
  ylabel('Phase (rad)');
   ylim([-1 1.1]);
   
  subplot(2, 3, 2);
  complex_plot(  fft(x(display_range1)), ['Orig Wave FFT '], 0, 1);
  xlim([0 100]);
  
end





x_lap = lap(x);
x_g = abs(x) ./ abs(x_lap);
x_g = medfilt1( abs(x) ./ abs(x_lap), 7);

x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));
x_g_pg = 1 ./ x_k_pg.^2;





if plots > 0
  subplot(2, 3, 3);
  complex_plot(  x_g(display_range1), [' \nabla |G*| Recovery, mean: ' num2str(round(mean(x_g(display_range1))))], 0, 1);
  ylim(ylims);
  xlim(xlims);
  ylabel('Pascals');
end

if (nargin > 2)
	x = filter(b_f, a_f, x);
  %x = conv(x, fspecial('gaussian', [750 1], 291), 'same');
   % x = conv(x, ones(512,1)/512, 'same');
%x = gradient(x);
  %x = conv(x, [-1 0 1], 'same');
  %x = x + y_cent;
end


  subplot(2, 3, 4);
  complex_plot(  x(display_range1), ['Low Pass Wave '], 0, 1);
  xlim(xlims);


  subplot(2, 3, 5);
  complex_plot(  fft(x(display_range1)), ['Low Pass FFT '], 0, 1);
  xlim([1 100]);

x_lap = lap(x);
x_g_lp = abs(x) ./ abs(x_lap);
x_k_lap = abs(sqrt(-lap(x)./x));
x_k_pg = gradient(unwrap(angle(x)));
x_g_pg_lp = 1 ./ x_k_pg.^2;

if plots > 0
  subplot(2, 3, 6);
  complex_plot( x_g_lp(display_range2), ['Low Pass \nabla |G*| Recovery, mean: ' num2str(round(mean(x_g_lp(display_range2))))], 0, 1);
   ylim(ylims);
   xlim(xlims);
   ylabel('Pascals');
end
 
 diff = mean(x_g(display_range1)) - mean(x_g_lp(display_range2))

 
end

