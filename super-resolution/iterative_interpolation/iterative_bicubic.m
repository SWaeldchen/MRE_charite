function x = iterative_bicubic(x, niter, target)
increment = target .^ (1 / niter);
for n = 1:niter
    x_rowspace = 1:rows(x);
    x_colspace = 1:columns(x);
    new_rowspace = linspace(1, rows(x), ceil(rows(x)*increment));
    new_colspace = linspace(1, columns(x), ceil(columns(x)*increment));
    [x_old y_old] = meshgrid(x_colspace, x_rowspace);
    [x_new y_new] = meshgrid(new_colspace, new_rowspace);
    x = interp2(x_old, y_old, x, x_new, y_new, 'pchip');
end