close all;
[ss_mean, ss_var] = roi_summary_stats(singlestack_, indices);
[ssh_mean, ssh_var] = roi_summary_stats(singlestacksh_, indices);
[ds_mean, ds_var] = roi_summary_stats(doublestack_, indices);
[dsl_mean, dsl_var] = roi_summary_stats(doublestackl_, indices);
[ds3_mean, ds3_var] = roi_summary_stats(doublestack3_, indices);
[ds2d_mean, ds2d_var] = roi_summary_stats(doublestack2D_, indices);
[dsc_mean, dsc_var] = roi_summary_stats(doublestackc_, indices);

figure(); hold on; 
plot(ss_var, 'LineWidth', 3);
plot(ssh_var, 'LineWidth', 3); 
plot(ds_var, 'LineWidth', 3);
plot(dsl_var, 'LineWidth', 3);
plot(ds3_var, 'LineWidth', 3);
plot(ds2d_var, 'LineWidth', 3);
plot(dsc_var, 'LineWidth', 3);
legend('single stack', 'high denoise single stack', 'double stack', 'low denoise double stack', ...
    '3d denoise double stack', '2D Laplacian', '3D compact laplacian');  title('Normalised Z axis Variance');
hold off;

figure(); hold on; 
plot(ss_mean, 'LineWidth', 3);
plot(ssh_mean, 'LineWidth', 3); 
plot(ds_mean, 'LineWidth', 3);
plot(dsl_mean, 'LineWidth', 3);
plot(ds3_mean, 'LineWidth', 3);
plot(ds2d_mean, 'LineWidth', 3);
plot(dsc_mean, 'LineWidth', 3);
legend('single stack', 'high denoise single stack', 'double stack', 'low denoise double stack', ...
    '3d denoise double stack', '2D Laplacian', '3D compact laplacian'); title('Means across volume');
hold off;
