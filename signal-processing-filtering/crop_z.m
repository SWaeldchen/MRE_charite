function y = crop_z(x, order_vector)

sz = size(x);
z_orig = max(order_vector);
firsts = find(order_vector==1);
index1 = firsts(1);
index2 = index1 + z_orig - 1;
sz_crop = sz;
sz_crop(3) = index2 - index1 + 1;
[x_resh, n_vols] = resh(x, 4);
y = zeros(sz_crop(1), sz_crop(2), sz_crop(3), n_vols);
for v = 1:n_vols
    y(:,:,:,v) = x_resh(:,:,index1:index2,v);
end

y = reshape(y, sz_crop);