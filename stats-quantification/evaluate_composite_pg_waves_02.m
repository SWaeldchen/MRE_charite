function [x, x_lap, x_g] = evaluate_composite_pg_waves_02

  close all;

  gradunit = 1/128;
  second_freq_amp_ratio = 0.2;
  
  vec1 = (sinVec(4096, 1024) * gradunit)';
  vec2 = (sinVec(4096, 128) * (gradunit * second_freq_amp_ratio))';

  net_offset = gradunit;

  k_set{1} = vec1 + net_offset;
  k_set{2} = vec2 + net_offset * second_freq_amp_ratio;

  cutoffL = 0.008;
  cutoffH = 0.3;
  
  [b_lo_4, a_lo_4] = butter(4, cutoffL, 'low');
  [b_lo_2, a_lo_2] = butter(2, cutoffL, 'low');
  [b_lo_1, a_lo_1] = butter(1, cutoffL, 'low');

  [b_hi_4, a_hi_4] = butter(4, cutoffH, 'high');
  [b_hi_2, a_hi_2] = butter(2, cutoffH, 'high');
  [b_hi_1, a_hi_1] = butter(1, cutoffH, 'high');

  b = {b_lo_1, b_lo_2, b_lo_4, b_hi_1, b_hi_2, b_hi_4};
  a = {a_lo_1, a_lo_2, a_lo_4, a_hi_1, a_hi_2, a_hi_4};
  
  composite_wave_demo_pg(k_set, gradunit);
  
  for n = 1:6
    composite_wave_demo_pg(k_set, gradunit, b{n}, a{n});
   end 
  
end
