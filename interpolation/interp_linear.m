function x_interp = interp_linear(x, fac)

sz = size(x);

rowspace_old = 1:sz(1);
colspace_old = 1:sz(2);
[x_old, y_old] = meshgrid(colspace_old, rowspace_old);

rowspace_new = 1:(1/fac):sz(1);
colspace_new = 1:(1/fac):sz(2);
[x_new, y_new] = meshgrid(colspace_new, rowspace_new);


x_interp = interp2(x_old, y_old, x, x_new, y_new, 'linear');
