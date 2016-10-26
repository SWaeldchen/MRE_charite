function [w_h] = composite_wave_demo(k_funcs, y_cent, b_f, a_f)

close all;

N = 512;

w1 = sinVec(N, 256);
w2 = sinVec(N, 64) / 2;
w3 = sinVec(N, 16) / 4;

displayRange = 3:N-2;

w = w1+w2+w3;

invert_plot_wave(hilbert(w1));

w_h = hilbert(w');

invert_plot_wave(w_h);

for lo = 0.005:0.005:0.03
	[b_lo, a_lo] = butter(4, lo, 'low');
	w_lo = filter(b_lo, a_lo, w_h);
	invert_plot_wave(w_lo);
end

[b_hi, a_hi] = butter(4, 0.2, 'high');
w_hi = filter(b_hi, a_hi, w_h);

invert_plot_wave(w_hi);



