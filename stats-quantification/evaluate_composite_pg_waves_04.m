function [x, x_lap, x_g] = evaluate_composite_pg_waves_04

  close all;

  gradunit = 1/500;
  second_freq_amp_ratio = 2;
  N = 2048;
  vec1 = (sinVec(N, 512) * gradunit)';
  vec2 = (sinVec(N, 128) * gradunit)';
  vec4 = circshift(fspecial('gaussian', [N 1], 4) * 1.2, -3*N/16);
  vec5 = circshift(fspecial('gaussian', [N 1], 4) * 0.8, -N/8);
  vec6 = circshift(fspecial('gaussian', [N 1], 4), -N/16);
  vec7 = circshift(fspecial('gaussian', [N 1], 4) * 1.3, 1);
  vec8 = circshift(fspecial('gaussian', [N 1], 4) * 0.9, N/16);
  vec9 = circshift(fspecial('gaussian', [N 1], 4) * 0.6, N/8);
  vec10 = circshift(fspecial('gaussian', [N 1], 4), 3*N/16);



  net_offset = 0.01;

  k1 = vec1 + net_offset;
 % k2 = vec2 + net_offset * second_freq_amp_ratio;
 % k2 = net_offset - (vec3 + vec4 + vec5);
 k2 = (vec4 + vec5 + vec7 + vec8 + vec9 + vec10);

  
  k_set = {k1/2 k2/2};
  k1_set = {k1/2, k1/2};
  k2_set = {k2/2, k2/2};

  cutoffL = 0.005;
  cutoffH = 0.05;
  
  [b_lo_4, a_lo_4] = butter(4, cutoffL, 'low');

  composite_wave_demo_pg_04(k_set, net_offset, b_lo_4, a_lo_4);
    
end
