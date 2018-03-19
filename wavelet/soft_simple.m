function y = soft_simple(x,T)

y = max(abs(x) - T, 0).*sign(x);

