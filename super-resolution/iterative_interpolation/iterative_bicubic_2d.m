function x = iterative_bicubic_2d(x, target, niter)
increment = target .^ (1 / niter);
rows = size(x, 1);
columns = size(x, 2);
for n = 1:niter
    old_rowspace = linspace(1, rows, rows);
    old_colspace = linspace(1, columns, columns);
    [x_old, y_old] = meshgrid(old_rowspace, old_colspace);
    new_rowspace = linspace(1, rows, rows*increment);
    new_colspace = linspace(1, columns, columns*increment);
    [x_new, y_new] = meshgrid(new_rowspace, new_colspace);    
    x = interp2(x_old, y_old, x, x_new, y_new, 'spline');
end
