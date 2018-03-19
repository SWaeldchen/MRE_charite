function y=awgn_nd(x, db)

[x_resh, n_vol] = resh(x, 4);
y_resh = zeros(size(x_resh));
for n = 1:n_vol
    y_resh(:,:,:,n) = awgn_eb(x_resh(:,:,:,n), db);
end
y = reshape(y_resh, size(x))