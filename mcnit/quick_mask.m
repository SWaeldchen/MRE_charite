function y = quick_mask(x, T)

y = mean(resh(abs(x),4),4) > T;