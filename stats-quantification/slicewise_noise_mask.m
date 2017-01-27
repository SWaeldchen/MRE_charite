function v = slicewise_noise_mask(u, mask)

u_resh = resh(u, 3);
n_slices = size(u_resh, 3);
v = zeros(n_slices, 1);
mask_reps = n_slices / size(mask, 3);
mask = repmat(mask, [1 1 mask_reps]);

for n = 1:n_slices;
    v(n) = mad_est_2d(u_resh(:,:,n), double(mask(:,:,n)));
end