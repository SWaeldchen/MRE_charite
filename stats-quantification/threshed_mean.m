function m = threshed_mean(x, thresh)

x = x(:);
m = mean(x(x >= thresh));