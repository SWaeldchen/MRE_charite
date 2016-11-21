function x = iterative_bicubic_3d(x, target, niter)
increment = target .^ (1 / niter);
for n = 1:niter
    old_rowspace = linspace(1, size(x,1), size(x,1));
    old_colspace = linspace(1, size(x,2), size(x,2));
    old_depth = linspace(1, size(x,3), size(x, 3));
    [x_old, y_old, z_old] = meshgrid(old_colspace, old_rowspace, old_depth);
    new_rowspace = linspace(1, size(x,1), size(x,1)*increment);
    new_colspace = linspace(1, size(x,2), size(x,2)*increment);
    new_depth = linspace(1, size(x,3), size(x,3)*increment);
    [x_new, y_new, z_new] = meshgrid(new_colspace, new_rowspace, new_depth);
    x = interp3(x_old, y_old, z_old, x, x_new, y_new, z_new, 'spline');
end