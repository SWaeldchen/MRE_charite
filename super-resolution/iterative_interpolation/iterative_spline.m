function x = iterative_gauss(x, niter, target, gauss)
if nargin < 4
  gauss = 0;
  end
  
increment = target .^ (1 / niter);
for n = 1:niter
    sigma = increment/3;
    x_rowspace = 1:rows(x);
    x_colspace = 1:columns(x);
    new_rowspace = linspace(1, rows(x), ceil(rows(x)*increment));
    new_colspace = linspace(1, columns(x), ceil(columns(x)*increment));
    [x_old y_old] = meshgrid(x_colspace, x_rowspace);
    [x_new y_new] = meshgrid(new_colspace, new_rowspace);
    x = interp2(x_old, y_old, x, x_new, y_new, 'spline');
    if gauss > 0
      g = fspecial('gaussian', [ceil(increment) ceil(increment)], sigma);
      x = conv2(x, g, 'same');
      end
      
end