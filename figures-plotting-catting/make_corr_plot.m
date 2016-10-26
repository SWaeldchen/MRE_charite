function make_corr_plot(sl)

range = [-5:0.01:0];
n_range = numel(range);
cut_corrs = zeros(size(range));
mean_core_diffs = zeros(size(range));
for n = 1 : numel(range)
    [cut_corr, mean_core_diff] = test_frequency_cuts(sl, range(n));
    cut_corrs(n) = cut_corr;
    mean_core_diffs(n) = mean_core_diff;
end
figure(); 
subplot(2, 1, 1); plot(range, mean_core_diffs);
subplot(2, 1, 2); plot(range, cut_corrs);