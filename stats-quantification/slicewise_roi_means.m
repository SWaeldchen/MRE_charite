function [y] = slicewise_roi_means(x, ROI)
z = size(x,3);
for n = 1:z
    temp = x(:,:,n);
    y(n) = mean(temp(ROI));
end