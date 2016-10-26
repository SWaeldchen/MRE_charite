function plot_jumps(jumps)
nj = numel(jumps);
figure
legend_ = cell(nj,1);
for n = 1:nj
    scatter(jumps{n}, repmat(n, [numel(jumps{n}), 1]));
    if n == 1
        hold on
    end
    legend_{n} = num2str(n);
end
hold off
legend(legend_);