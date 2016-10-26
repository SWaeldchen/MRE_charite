function y = thresh_with_other_volume(x, xx)
sz = size(x);
y = zeros(sz);
%mask = find(x(:,:,:,1) > thresh);
for n = 1:sz(4)
    tempX = x(:,:,:,n);
    tempY = zeros(size(tempX));
    mask = find(xx(:,:,:,n) ~= 0);
    tempY(mask) = tempX(mask);
    y(:,:,:,n) = tempY;
end