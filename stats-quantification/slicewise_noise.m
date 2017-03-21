function v = slicewise_noise(u)

u_resh = resh(u, 3);
n_slices = size(u_resh, 3);
v = zeros(n_slices, 1);

for n = 1:n_slices
    v(n) = mad_est_2d(u_resh(:,:,n), double(middle_circle(u_resh(:,:,n))));
end