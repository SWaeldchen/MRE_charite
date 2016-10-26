function [x, x_lap, x_g] = evaluate_composite_pg_waves_03

  close all;

  gradunit = 1/500;
  second_freq_amp_ratio = 2;
  N = 2048;
  vec1 = (sinVec(N, 512) * gradunit)';
  vec2 = (sinVec(N, 128) * gradunit)';
  vec3 = fspecial('gaussian', [N 1], 6) / 10;
  vec4 = circshift(fspecial('gaussian', [N 1], 8) / 5, N/8);
  vec5 = circshift(fspecial('gaussian', [N 1], 32) / 2, -N/8);


  net_offset = 0.01;

  k1 = vec1 + net_offset;
 % k2 = vec2 + net_offset * second_freq_amp_ratio;
  k2 = net_offset - (vec3 + vec4 + vec5);

  
  k_set = {k1/2 k2/2};
  k1_set = {k1/2, k1/2};
  k2_set = {k2/2, k2/2};

  cutoffL = 0.005;
  cutoffH = 0.05;
  
  [b_lo_4, a_lo_4] = butter(4, cutoffL, 'low');

  [b_hi_4, a_hi_4] = butter(4, cutoffH, 'high');
 
  b = {b_lo_4, b_hi_4};
  a = {a_lo_4, a_hi_4};
  
  composite_wave_demo_pg_03(k1_set, net_offset);
  composite_wave_demo_pg_03(k2_set, net_offset);
  composite_wave_demo_pg_03(k_set, net_offset);
  composite_wave_demo_pg_03(k_set, net_offset, b_lo_4, a_lo_4);
  
  
end
