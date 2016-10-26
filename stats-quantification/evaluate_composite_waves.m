function [x, x_lap, x_g] = evaluate_composite_waves

  close all;

  k_set_1 = cell(1,1);
  k_set_2 = cell(1,1);
  k_set_3 = cell(1,1);
  k_set_4 = cell(2,1);
  k_set_5 = cell(2,1);
  k_set_6 = cell(3,1);
  
  vec1 = (sinVec(1024, 512) / 100)';
  vec2 = (sinVec(1024, 32) / 500)';
  vec3 = (sinVec(1024, 16) / 100)';

  net_offset = .06;

  k_set_1{1} = vec1 + net_offset;
  k_set_4{1} = vec1 + net_offset / 2;  
  k_set_6{1} = vec1 + net_offset / 3;
  
  k_set_2{1} = vec2 + net_offset;
  k_set_4{2} = vec2 + net_offset / 2;
  k_set_5{1} = vec2 + net_offset / 2;
  k_set_6{2} = vec2 + net_offset / 3;
  
  k_set_3{1} = vec3 + net_offset;
  k_set_5{2} = vec3 + net_offset / 2;
  k_set_6{3} = vec3 + net_offset / 3;

  loval = 0.02
  hival = 0.4
  
  bp_set = [.02 .03 .04 .05 .06 .07 .08];

  k_set_mirror = [k_set_4 fliplr(k_set_4)];
  
  for n = 1:numel(bp_set)
    [b, a] = butter(4, bp_set(n), 'high');
	
    [x, x_lap, x_g] = composite_wave_demo(k_set_mirror, net_offset, b, a);
  end
  
  

  
  %{
  
  [b_lo, a_lo] = butter(4, loval, 'low');
  [b_hi, a_hi] = butter(4, hival, 'high');
  [b_mid, a_mid] = butter(4, [loval hival]);
 
  %composite_wave_demo(k_set_1, net_offset);
  %composite_wave_demo(k_set_2, net_offset);
  %composite_wave_demo(k_set_3, net_offset);
  %composite_wave_demo(k_set_4, net_offset);
  %composite_wave_demo(k_set_5, net_offset);
  %composite_wave_demo(k_set_6, net_offset);
  composite_wave_demo(k_set_6, net_offset, b_lo, a_lo);
  composite_wave_demo(k_set_6, 0.2, b_hi, a_hi);
  composite_wave_demo(k_set_6, net_offset, b_mid, a_mid);
  
  %}
  
  
  
end
