function x_crop = mircrop(x, n_slcs)

szx = size(x);
x_resh = resh(x, 4);
z_indices = n_slcs+1:(szx(3)-n_slcs);
x_crop = x_resh(:,:,z_indices,:);
if size(x_resh, 4) > 1
    x_crop = reshape(x_crop, [szx(1) szx(2) numel(z_indices) szx(4:end)]);
else
    x_crop = reshape(x_crop, [szx(1) szx(2) numel(z_indices)]);
end   