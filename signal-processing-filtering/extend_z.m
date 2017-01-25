function [y, order_vector] = extend_z(x, dim)

sz = size(x);
sz_ex = sz;
sz_ex(3) = dim;
[x_resh, n_vols] = resh(x, 4);
y = zeros(sz_ex(1), sz_ex(2), sz_ex(3), n_vols);

for v = 1 : n_vols
    x = x_resh(:,:,:,v);
    origDepth = sz(3);
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
        y(:,:,n,v) = x(:,:,curSlc);
        order_vector(n) = curSlc;

    end
end

y = reshape(y, sz_ex);