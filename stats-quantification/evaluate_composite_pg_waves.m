function [x, x_lap, x_g] = evaluate_composite_pg_waves

  close all;

  k_set_1 = cell(1,1);
  k_set_2 = cell(1,1);
  k_set_3 = cell(1,1);
  k_set_4 = cell(2,1);
  k_set_5 = cell(2,1);
  k_set_6 = cell(3,1);
  
  gradunit = 1/128;
  second_freq_amp_ratio = 0.2;
  
  vec1 = (sinVec(8192, 256) * gradunit)';
  vec2 = (sinVec(8192, 32) * (gradunit * second_freq_amp_ratio))';
  vec3 = (sinVec(9000, 16) / 512)';

  net_offset = gradunit;

  k_set_1{1} = vec1 + net_offset;
  k_set_4{1} = vec1;  
  k_set_6{1} = vec1 + net_offset / 3;
  
  k_set_2{1} = vec2 + net_offset;
  k_set_4{2} = vec2 + net_offset / second_freq_amp_ratio;
  k_set_5{1} = vec2 + net_offset / 2;
  k_set_6{2} = vec2 + net_offset / 3;
  
  k_set_3{1} = vec3 + net_offset;
  k_set_5{2} = vec3 + net_offset / 2;
  k_set_6{3} = vec3 + net_offset / 3;

  cutoff = .05;
  
  [b_lo_4, a_lo_4] = butter(4, cutoff, 'low');
  [b_lo_2, a_lo_2] = butter(2, cutoff, 'low');
  [b_lo_1, a_lo_1] = butter(1, cutoff, 'low');

  [b_hi_4, a_hi_4] = butter(4, cutoff, 'high');
  [b_hi_2, a_hi_2] = butter(2, cutoff, 'high');
  [b_hi_1, a_hi_1] = butter(1, cutoff, 'high');

  b = {b_lo_1, b_lo_2, b_lo_4, b_hi_1, b_hi_2, b_hi_4};
  a = {a_lo_1, a_lo_2, a_lo_4, a_hi_1, a_hi_2, a_hi_4};
  
  composite_wave_demo_pg(k_set_4, gradunit);
  %{
  for n = 1:6
    composite_wave_demo_pg(k_set_4, cutoff, b{n}, a{n});
   end 
  %}
end
