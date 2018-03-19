function [y, order_vector] = mirror_z_5d(x, dim)
if (nargin < 2)
    dim = 128;
end
szx = size(x);
y = zeros(szx(1), szx(2), dim, szx(4), szx(5));
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
   
    y(:,:,n,:,:) = x(:,:,curSlc,:,:);
    order_vector(n) = curSlc;
end