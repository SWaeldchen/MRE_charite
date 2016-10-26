function [y, order_vector] = extendZ(x, dim)

szx = size(x);
y = zeros(dim, dim, dim);
origDepth = szx(3);
tile = origDepth*2-2;
order_vector = zeros(dim,1);
for n = 1 :	dim
    m = n-1;
    index =  mod((m), tile)+1;
    if index < origDepth
        curSlc = origDepth - index + 1;
    end
    
    if index >= origDepth 
        curSlc = index - origDepth + 1;
    end
    y(1:szx(1),1:szx(2),n) = x(:,:,curSlc);
    order_vector(n) = curSlc;
   
end

 yPad = dim - szx(1);
 xPad = dim - szx(2);
 

for m = 1: dim
    
    yFlip = flipud(y(1:szx(1),1:szx(2),m));
    szyf = size(yFlip);
    y(szx(1)+1:end, 1:szyf(2), m) = yFlip(1:yPad, :);
    
    xFlip = fliplr(y(:,1:szx(2),m));
    y(:, szx(2)+1:end, m) = xFlip(:, 1:xPad);
    
    
end
