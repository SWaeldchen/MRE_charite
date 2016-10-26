function [diff] = multiscale_illustration


close all;

base = ones(288,1)*3;
features = [zeros(16,1); repmat([ 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0  0 1 0 0 0 0 0 0 0 0 0 0]', [8, 1]); zeros(16,1)];

mu_gt = base - 2*features;
% mu = rho*f^2*lambda^2q
% unit rhoq
% norm freqs 2, 3
f1 = 2;
f2 = 3;
gridsize = 1 / 128;

lambda1 = sqrt(mu_gt / f1^2) / gridsize;
lambda2 = sqrt(mu_gt / f2^2) / gridsize;

k1 = 2*pi./lambda1;
k2 = 2*pi./lambda2;

%k1 = (base + features) / 128 * 3.1;
%k2 = k1 * freq_scale;

w1 = phase_grad_to_wave(k1);
w2 = phase_grad_to_wave(k2);

display_range = 17:272;
ds_display_range = round(display_range(1) / 4):round(display_range(end)/4);

figure;

subplot(9, 2, 1); complex_plot(k1(display_range), 'k^{1}_{gt}', 0, 1);
subplot(9, 2, 2); complex_plot(k2(display_range), 'k^{2}_{gt}', 0, 1);
subplot(9, 2, 3); complex_plot(w1(display_range), 'U^{1}_{gt}', 0, 1);
subplot(9, 2, 4); complex_plot(w2(display_range), 'U^{2}_{gt}', 0, 1);
subplot(9, 2, 5); complex_plot(pwrspec(w1(display_range)), 'FT(U_{1}', 0, 1);
subplot(9, 2, 6); complex_plot(pwrspec(w2(display_range)), 'FT(U_{2}', 0, 1);

w1_ds = w1(1:4:end);
w2_ds = w2(1:4:end);

subplot(9, 2, 7); complex_plot(w1_ds(ds_display_range), 'U^{1}_{ds}', 0, 1);
subplot(9, 2, 8); complex_plot(w2_ds(ds_display_range), 'U^{2}_{ds}', 0, 1);
subplot(9, 2, 9); complex_plot(pwrspec(w1_ds(ds_display_range)), 'FT(U^{1}_{ds})', 0, 1);
subplot(9, 2, 10); complex_plot(pwrspec(w2_ds(ds_display_range)), 'FT(U^{2}_{ds})', 0, 1);

k1_ds = gradient(unwrap(angle(w1_ds)));
k2_ds = gradient(unwrap(angle(w2_ds)));
mu1_ds = f1^2 ./ k1_ds.^2;
mu2_ds = f2^2 ./ k2_ds.^2;
mu_ds = mu1_ds + mu2_ds;

w1_recov = spline_interp(w1_ds, 4);
w2_recov = spline_interp(w2_ds, 4);

k1_recov = gradient(unwrap(angle(w1_recov)));
k2_recov = gradient(unwrap(angle(w2_recov)));

mu1_recov = (2*pi*gridsize./k1_recov).^2.*f1^2;
mu2_recov = (2*pi*gridsize./k2_recov).^2.*f2^2;

k_recov_comb = (k1_recov / 2 + k2_recov / 3);
mu_recov = (2*pi*gridsize./k_recov_comb).^2;


mu_recov = (mu1_recov + mu2_recov) / 2;
 diff = mu1_recov - mu2_recov;

subplot(9, 2, 11); complex_plot(mu1_ds(ds_display_range), '', 0, 1);
subplot(9, 2, 12); complex_plot(k1_recov(display_range), '', 0, 1);
subplot(9, 2, 13); complex_plot(mu_gt(display_range), '\mu_{gt}', 0, 1);

%subplot(9, 2, 14); complex_plot(pwrspec(k1_recov(display_range)),'',0,1);
%subplot(9, 2, 15); complex_plot(pwrspec(k2_recov(display_range)),'',0,1);

subplot(9, 2, 14); complex_plot(pwrspec(w1_recov(display_range)),'',0,1);
subplot(9, 2, 15); complex_plot(mu1_recov(display_range),'',0,1);

subplot(9, 2, 16); complex_plot(diff(display_range),'',0,1);

figure();
plot(mu1_recov(display_range), 'r', 'linewidth', 3);
hold on;
plot(mu2_recov(display_range), 'g', 'linewidth', 2);
plot(mu_recov(display_range), 'b', 'linewidth', 1);



