function v = slicewise_noise_middles(u)

u_resh = resh(u, 3);
n_slices = size(u_resh, 3);
q1 = round(3*n_slices./8);
q3 = round(5*n_slices/8);
v = zeros(q3-q1+1, 1);

for n = q1:q3;
    v(n-q1+1) = mad_est_2d(u_resh(:,:,n), double(middle_circle_tight(u_resh(:,:,n))));
end