function y = slicewise_mean_nozeros(x)

[x, n_slcs] = resh(x, 3);
y = zeros(n_slcs, 1);
for n = 1:n_slcs
    x_slc = x(:,:,n);
    y(n) = mean(x_slc(x_slc~=0));
end