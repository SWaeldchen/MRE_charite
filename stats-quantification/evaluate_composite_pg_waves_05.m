function [x, x_lap, x_g] = evaluate_composite_pg_waves_05

  close all;

  gradunit = 1/500;
  second_freq_amp_ratio = 2;
  N = 2048;
  coef = 0.1;
  base_width = 13;
  vec1 = (sinVec(N, 512, pi/4) * gradunit)';
  %vec2 = (sinVec(N, 128) * gradunit)';
  vec4 = circshift(fspecial('gaussian', [N 1], base_width) * coef, -3*N/16 + round(randn*10));
  vec5 = circshift(fspecial('gaussian', [N 1], base_width*0.7) * 0.6* coef, -N/8 + round(randn*10));
  vec6 = circshift(fspecial('gaussian', [N 1], base_width*1.3) *coef, -N/16 + round(randn*10));
  vec7 = circshift(fspecial('gaussian', [N 1], base_width*1.2) * coef, 1 + round(randn*10));
  vec8 = circshift(fspecial('gaussian', [N 1], base_width*0.5) * 0.6 * coef, N/16 + round(randn*10));
  vec9 = circshift(fspecial('gaussian', [N 1], base_width*0.7) * 0.4*coef, N/8 + round(randn*10));
  vec10 = circshift(fspecial('gaussian', [N 1], base_width*0.8) *coef, 3*N/16 + round(randn*10));
  vec11 = circshift(fspecial('gaussian', [N 1], base_width*1.1) * coef, -N/4 + round(randn*10));
  vec12 = circshift(fspecial('gaussian', [N 1], base_width) * coef, N/16 + round(randn*10));
  vec13 = circshift(fspecial('gaussian', [N 1], base_width*0.8) * coef, N/4 + round(randn*10));
  vec14 = circshift(fspecial('gaussian', [N 1], base_width*0.9) * coef, 0);



  net_offset = 0.01;

  k1 = vec1 + vec14 + net_offset;
 % k2 = vec2 + net_offset * second_freq_amp_ratio;
 % k2 = net_offset - (vec3 + vec4 + vec5);
 %k2 = (vec4 + vec8 + vec11);
 k2 = (vec4 + vec6 + vec8 + vec10 + vec12);
 k3 = (vec5 + vec9 + vec11 + vec13);
 
 magvector = 1-k2+k3;
 %k2 = 0;
  

  cutoffL = 0.007;
  %cutoffL = 0.001;

  
  [b_lo_4, a_lo_4] = butter(4, cutoffL, 'low');

  composite_wave_demo_pg_05(k1, magvector, b_lo_4, a_lo_4);
    
end
