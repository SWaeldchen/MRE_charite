function [diff] = ieee_undershoot_demo(base_width, amp_coeff, plots)

%% DEMO VALS FOR LOW PASS UNDERSHOOT (HARDER FEATURES): base_width 21 MAGVECTOR_WIDTH 11 amp_coeff -10 MAGVECTOR_COEF -50
%% DEMO VALS FOR LOW PASS OVERSHOOT (SOFTER FEATURES): base_width 11 MAGVECTOR_WIDTH 15 amp_coeff 15 MAGVECTOR_COEF 100


if nargin < 3
  plots = 0;
  end

  close all;

  gradunit = 1/100;
  second_freq_amp_ratio = 2;
  N = 2048;
  coef = 1;
  phase_grad = (sinVec(N, 1024, 0) * gradunit)';
  phase_grad = ones(size(phase_grad))*gradunit + phase_grad/500;
  
  
  spikes_gauss{1} = circshift(fspecial('gaussian', [N 1], base_width*1.3) * 0.6*coef, -N/4 + round(randn*10));
  spikes_gauss{2} = circshift(fspecial('gaussian', [N 1], base_width*1.2) * 0.8*coef, -3*N/16 + round(randn*10));
  spikes_gauss{3} = circshift(fspecial('gaussian', [N 1], base_width*1.3) * 0.6*coef, -N/8 + round(randn*10));
  spikes_gauss{4} = circshift(fspecial('gaussian', [N 1], base_width*1.1) *0.9*coef, -N/16 + round(randn*10));
  spikes_gauss{5} = circshift(fspecial('gaussian', [N 1], base_width*1) * coef, 1 + round(randn*10));
  spikes_gauss{6} = circshift(fspecial('gaussian', [N 1], base_width*1.2) * 0.6 * coef, N/16 + round(randn*10));
  spikes_gauss{7} = circshift(fspecial('gaussian', [N 1], base_width*1.3) * 0.6 *coef, N/8 + round(randn*10));
  spikes_gauss{8} = circshift(fspecial('gaussian', [N 1], base_width*1.4) *0.5*coef, 3*N/16 + round(randn*10));
  spikes_gauss{9} = circshift(fspecial('gaussian', [N 1], base_width*1.2) * 0.8* coef, N/4 + round(randn*10));
  
  % add this one to wavenumber
  

  urspike = zeros(N, 1); 
  spike_range = round(N/2)-base_width:round(N/2)+base_width
  urspike(spike_range) = ones(size(spike_range))*amp_coeff;
  spikes_step{1} = circshift(urspike, -N/4 + round(randn*10));
  spikes_step{2} = circshift(urspike, -3*N/16 + round(randn*10));
  spikes_step{3} = circshift(urspike, -N/8 + round(randn*10));
  spikes_step{4} = circshift(urspike, -N/16 + round(randn*10));
  spikes_step{5} = circshift(urspike, 1 + round(randn*10));
  spikes_step{6} = circshift(urspike, N/16 + round(randn*10));
  spikes_step{7} = circshift(urspike, N/8 + round(randn*10));
  spikes_step{8} = circshift(urspike, 3*N/16 + round(randn*10));
  spikes_step{9} = circshift(urspike, N/4 + round(randn*10));
  %}
  
  spikes = spikes_step;
  
 lospikes = spikes{1} + spikes{2};
 lomidspikes = spikes{3} + spikes{4};
 midspike = spikes{5};
 himidspikes = spikes{6} + spikes{7};
 hispikes = spikes{8} + spikes{9};
 
 spikevector = zeros(size(phase_grad)) + himidspikes + lomidspikes + hispikes;
 
 % alter phase grad
  phase_grad = phase_grad + spikevector.*amp_coeff;
  magvector = ones(size(phase_grad));% .* (2 - spikevector); 
 
 % alter magnitude;
 %magvector = ones(size(phase_grad)) + spikevector;% .* (2 - spikevector); 
 
 
 figure(); plot(phase_grad); title('Wavenumber');
 
  cutoffH = 0.05;
  
  [b_lo_4, a_lo_4] = butter(4, cutoffH);
  
  diff = ieee_undershoot_wave_generation(phase_grad, magvector, b_lo_4, a_lo_4, plots);
  
  display(['base_width ', num2str(base_width)]);
  display(['amp_coeff ', num2str(amp_coeff)]);
    
end
