function J = TV(y, smoothing_param)
   [gradx, grady] = gradient(y);
   smoothed_TV = smoothed_L1(gradx, grady, smoothing_param);
   J = sum(smoothed_TV(:));
end