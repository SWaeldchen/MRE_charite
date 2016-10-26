function [roi_means, roi_vars] = roi_summary_stats(stack, indices)

sz = size(stack);
roi_means = zeros(sz(4), 1);
roi_vars = zeros(sz(4), 1);
vals = [];
for m = 1:sz(4)
    for n = 1:sz(3)
        temp = stack(:,:,n,m);
        vals = cat(2, vals, temp(indices));
    end
    roi_means(m) = mean(vals);
end
vars = zeros(numel(indices), sz(4));
for p = 1:numel(indices)
    [i,j] = ind2sub([sz(1), sz(2)], indices(p));
    for m = 1:sz(4)
        vars(p, m) = std(stack(i,j,:,m)) ./ roi_means(m);
    end
end
roi_vars = mean(vars, 1);
