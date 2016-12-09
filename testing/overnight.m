<<<<<<< HEAD
mu = sfwi(jgo(:,:,:,:,:,2:6), [30 50 40 45 35], [.002 .002 .002], 1, 1, 1, 2, -1, 1, 1);
save('jgo_sfwi', 'mu');

mu_2x = sfwi(additive_sr(jgo(:,:,:,:,:,2:6),2), [30 50 40 45 35], [.002 .002 .002], 1, 1, 1, 2, -1, 1, 1);
save('jgo_sfwi', 'mu', 'mu_2x');

mu_4x = sfwi(additive_sr(jgo(:,:,:,:,:,2:6),4), [30 50 40 45 35], [.002 .002 .002], 1, 1, 1, 2, -1, 1, 1);
save('jgo_sfwi', 'mu', 'mu_2x', 'mu_4x');
=======
alpha = [0.1 0.2 0.3];
lambda = [10 20 30];
mu = cell(numel(alpha),numel(lambda));
for alf = 1:numel(alpha)
    for lam = 1:numel(lambda)
        mu{alf,lam} = full_wave_inversion(additive_sr(preproc_ch(:,:,:,:,2:4),2,alpha(alf),lambda(lam)), [30 50 40], [.002 .002 .002], 1, 2);
        save('ch_sr_tests_2', 'mu');
    end
end
>>>>>>> 14803ebee41767e1a5bf2a62664855d932748d33
