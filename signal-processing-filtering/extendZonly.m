function [y, order_vector] = extendZonly(x, dim)

szx = size(x);
y = zeros(szx(1), szx(2), dim);
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
