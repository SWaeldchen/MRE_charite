function y = thresh_volumes(x, thresh)
sz = size(x);
y = zeros(sz);
for n = 1:sz(4)
    x_temp = x(:,:,:,n);
    mask = find(x_temp>thresh);
    y_temp = zeros(size(x_temp));
    y_temp(mask) = x_temp(mask);
    y(:,:,:,n) = y_temp;
end

    