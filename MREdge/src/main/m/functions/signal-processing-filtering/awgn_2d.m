function y=awgn_2d(x, db)

[x_resh, n_slc] = resh(x, 3);
y_resh = zeros(size(x_resh));
for n = 1:n_slc
    y_resh(:,:,n) = awgn_eb(x_resh(:,:,n), db, 'measured');
end
y = reshape(y_resh, size(x));