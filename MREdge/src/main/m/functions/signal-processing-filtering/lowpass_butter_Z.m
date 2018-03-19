function [y] = lowpass_butter_Z(x, norm_freq)

[b, a] = butter(4, norm_freq, 'low');
sz = size(x);
x = shiftdim(x, 2);
y = filter(b, a, x);
y = shiftdim(y,numel(sz)-2);