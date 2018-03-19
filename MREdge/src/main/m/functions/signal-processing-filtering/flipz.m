function x_flip = flipz(x)

sz = size(x);
if ndims(x) > 3
    dims_after_3 = prod(sz(4:end));
else
    dims_after_3 = 1;
end
x_resh = reshape(x, [sz(1), sz(2), sz(3), dims_after_3]);
x_resh_flip = x_resh(:,:,end:-1:1,:);
x_flip = reshape(x_resh_flip, sz);