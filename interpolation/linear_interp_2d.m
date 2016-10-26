function y = linear_interp_2d(x, f)

x = linear_interp(x, f);
x = permute(x, [2 1]);
x = linear_interp(x,f);
y = permute(x, [2 1]);
