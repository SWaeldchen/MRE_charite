function x = iterative_bicubic_3d(x, target, niter)
increment = target .^ (1 / niter);
for n = 1:niter
    old_rowspace = linspace(1, rows(x), rows(x));
    old_colspace = linspace(1, columns(x), columns(x));
    old_depth = linspace(1, size(x,3), size(x, 3));
    [x_old, y_old, z_old] = meshgrid(old_rowspace, old_colspace, old_depth);
    new_rowspace = linspace(1, rows(x), rows(x)*increment);
    new_colspace = linspace(1, columns(x), columns(x)*increment);
    new_depth = linspace(1, size(x,3), size(x,3)*increment);
    x = interp3(old_rowspace, old_colspace, old_depth, x, new_rowspace, new_colspace, new_depth, 'spline');
end