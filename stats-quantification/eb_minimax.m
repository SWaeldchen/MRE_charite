function y = eb_minimax(x);

x = x(:);
y = (max(x) - min(x)) / mean(x);
