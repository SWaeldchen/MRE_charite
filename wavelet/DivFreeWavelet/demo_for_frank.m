load('brain_for_frank.mat');

minSize = [8 8 8];
res = [1 1 1];
spins = 8;
isRand = 0;

% split real and imag

vx_r = real(brain(:,:,:,1));
vy_r = real(brain(:,:,:,2));
vz_r = real(brain(:,:,:,3));

vx_i = imag(brain(:,:,:,1));
vy_i = imag(brain(:,:,:,2));
vz_i = imag(brain(:,:,:,3));

% acquire divergence-free components
[vx_df_r, vy_df_r, vz_df_r] = dfwavelet_thresh_spin(vx_r, vy_r, vz_r, minSize, res, eps, Inf, spins, isRand);
[vx_df_i, vy_df_i, vz_df_i] = dfwavelet_thresh_spin(vx_i, vy_i, vz_i, minSize, res, eps, Inf, spins, isRand);

% acquire non-divergence-free components
[vx_ndf_r, vy_ndf_r, vz_ndf_r] = dfwavelet_thresh_spin(vx_r, vy_r, vz_r, minSize, res, Inf, eps, spins, isRand);
[vx_ndf_i, vy_ndf_i, vz_ndf_i] = dfwavelet_thresh_spin(vx_i, vy_i, vz_i, minSize, res, Inf, eps, spins, isRand);

% acquire components weighted toward divergence-free
[vx_wdf_r, vy_wdf_r, vz_wdf_r] = dfwavelet_thresh_spin(vx_r, vy_r, vz_r, minSize, res, 10, 20, spins, isRand);
[vx_wdf_i, vy_wdf_i, vz_wdf_i] = dfwavelet_thresh_spin(vx_i, vy_i, vz_i, minSize, res, 10, 20, spins, isRand);

% acquire components weighted toward non-divergence-free
[vx_wndf_r, vy_wndf_r, vz_wndf_r] = dfwavelet_thresh_spin(vx_r, vy_r, vz_r, minSize, res, 20, 10, spins, isRand);
[vx_wndf_i, vy_wndf_i, vz_wndf_i] = dfwavelet_thresh_spin(vx_i, vy_i, vz_i, minSize, res, 20, 10, spins, isRand);

% recombine real and imag
vx_df = vx_df_r + 1i*vx_df_i;
vy_df = vy_df_r + 1i*vy_df_i;
vz_df = vz_df_r + 1i*vz_df_i;

vx_ndf = vx_ndf_r + 1i*vx_ndf_i;
vy_ndf = vy_ndf_r + 1i*vy_ndf_i;
vz_ndf = vz_ndf_r + 1i*vz_ndf_i;

vx_wdf = vx_wdf_r + 1i*vx_wdf_i;
vy_wdf = vy_wdf_r + 1i*vy_wdf_i;
vz_wdf = vz_wdf_r + 1i*vz_wdf_i;

vx_wndf = vx_wndf_r + 1i*vx_wndf_i;
vy_wndf = vy_wndf_r + 1i*vy_wndf_i;
vz_wndf = vz_wndf_r + 1i*vz_wndf_i;

% quick wave inversion on each wave field
absg_df = quick_3d_wave_inversion(vx_df, vy_df, vz_df);
absg_ndf = quick_3d_wave_inversion(vx_ndf, vy_ndf, vz_ndf);
absg_wdf = quick_3d_wave_inversion(vx_wdf, vy_wdf, vz_wdf);
absg_wndf = quick_3d_wave_inversion(vx_wndf, vy_wndf, vz_wndf);

figure;

subplot(2, 2, 1); imshow(absg_df(:,:,7), []); title('Divergence-Free Component');
subplot(2, 2, 2); imshow(absg_ndf(:,:,7), []); title('Non-divergence-free Component');
subplot(2, 2, 3); imshow(absg_wdf(:,:,7), []); title('Weighted toward divergence-free');
subplot(2, 2, 4); imshow(absg_wndf(:,:,7), []); title('Weighted toward non-divergence-free'); 