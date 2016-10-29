function [resids, means] = lsqr_iter_stability_test(U, freqvec, spacing)

niters = [5 10 50 100 200 300 500 1000];
resids = [];
means = [];

for n = niters
    disp(num2str(n));
    [mu, ~, resid] = full_wave_inversion(U, freqvec, spacing, n);
    resids = cat(1, resids, resid);
    mc = middle_circle(abs(mu));
    mn = mean(mc(~isnan(mc)));
    means = cat(1, means, mn);
end