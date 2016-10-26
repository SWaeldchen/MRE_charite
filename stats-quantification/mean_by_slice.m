function [y] = mean_by_slice(x, ROI)

sz = size(x);
y = zeros(sz(3),1);
for n = 1:sz(3)
    temp = x(:,:,n);
    y(n) = mean(temp(ROI));
end