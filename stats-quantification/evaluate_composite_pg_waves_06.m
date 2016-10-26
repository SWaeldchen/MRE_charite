function [x, x_lap, x_g] = evaluate_composite_pg_waves_06(phase_width, magvector_width, phase_coeff, magvector_coeff)

%% DEMO VALS FOR LOW PASS UNDERSHOOT (HARDER FEATURES): PHASE_WIDTH 21 MAGVECTOR_WIDTH 11 PHASE_COEFF -10 MAGVECTOR_COEF -50
%% DEMO VALS FOR LOW PASS OVERSHOOT (SOFTER FEATURES): PHASE_WIDTH 11 MAGVECTOR_WIDTH 15 PHASE_COEFF 15 MAGVECTOR_COEF 100


  close all;

  gradunit = 1/1000;
  second_freq_amp_ratio = 2;
  N = 2048;
  coef = 0.007;
  base_width = 21;
  phase_grad = (sinVec(N, 768, pi/4) * gradunit)';
  
  
  spike1 = circshift(fspecial('gaussian', [N 1], phase_width*1.3) * coef, -N/4 + round(randn*10));
  spike2 = circshift(fspecial('gaussian', [N 1], phase_width*1.2) * coef, -3*N/16 + round(randn*10));
  spike3 = circshift(fspecial('gaussian', [N 1], phase_width*1.1) * coef, -N/8 + round(randn*10));
  spike4 = circshift(fspecial('gaussian', [N 1], phase_width*1) *coef, -N/16 + round(randn*10));
  spike5 = circshift(fspecial('gaussian', [N 1], magvector_width*1) * coef, 1 + round(randn*10));
  spike6 = circshift(fspecial('gaussian', [N 1], magvector_width*1.2) * 0.6 * coef, N/16 + round(randn*10));
  spike7 = circshift(fspecial('gaussian', [N 1], magvector_width*1.3) * 0.6 *coef, N/8 + round(randn*10));
  spike8 = circshift(fspecial('gaussian', [N 1], magvector_width*1.4) *coef, 3*N/16 + round(randn*10));
  spike9 = circshift(fspecial('gaussian', [N 1], magvector_width*1.2) * 0.8* coef, N/4 + round(randn*10));
  % add this one to wavenumber



  net_offset = 0.01;

 lospikes = spike1 + spike2;
 lomidspikes = spike3 + spike4;
 midspike = spike5;
 himidspikes = spike6 + spike7;
 hispikes = spike8+ spike9;
 
 phase_grad = phase_grad + net_offset  + phase_coeff*lomidspikes + phase_coeff*lospikes;
 magvector = ones(size(phase_grad)) + magvector_coeff*himidspikes + magvector_coeff*hispikes; % + lomidspikes + lospikes;
 
  %phase_grad = phase_grad + net_offset  + 3*lomidspikes + 3*lospikes;
 %magvector = ones(size(phase_grad)) + 10*himidspikes + 10*hispikes; % + lomidspikes + lospikes;
 
  cutoffL = 0.003;
  
  [b_lo_4, a_lo_4] = butter(4, cutoffL, 'low');

  composite_wave_demo_pg_06(phase_grad, magvector, b_lo_4, a_lo_4);
  
  display(['phase_width ', num2str(phase_width)]);
  display(['magvector_width ', num2str(magvector_width)]);
  display(['phase_coeff ', num2str(phase_coeff)]);
  display(['magvector_coeff ', num2str(magvector_coeff)]);
    
end
