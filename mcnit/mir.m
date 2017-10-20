function x_mir = mir(x, n_slcs)

szx = size(x);
x_resh = resh(x, 4);
z_indices = [(n_slcs+1):-1:2, 1:1:szx(3), (szx(3)-1):-1:(szx(3)-n_slcs)];

x_mir = x_resh(:,:,z_indices,:);
if size(x_resh, 4) > 1
    x_mir = reshape(x_mir, [szx(1) szx(2) numel(z_indices) szx(4:end)]);
else
    x_mir = reshape(x_mir, [szx(1) szx(2) numel(z_indices)]);
end    