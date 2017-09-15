function A = spdiag(x)
N = numel(x);
A = spdiags(x(:), 0, N, N);
