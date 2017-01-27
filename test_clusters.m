function [cluster_means, handles] = test_clusters(data, cluster_range)

mx = repmat(max(data, [], 1), [size(data,1) 1]);
mn = repmat(min(data, [], 1), [size(data,1) 1]);

data = (data - mn) ./ (mx - mn);

n_clusters = numel(cluster_range);
cluster_means = zeros(n_clusters, 2);
handles = cell(n_clusters,1);
figure(1); set(gcf, 'color', 'w');
for c = 1:numel(cluster_range)
    subplot(n_clusters / 2, 2, c);
    idx_c = kmeans(data, cluster_range(c),'Display','final','Replicates',100);
    [silh_c, h] = silhouette(data, idx_c);
    handles{c} = h;
    cluster_means(c,1) = cluster_range(c);
    cluster_means(c,2) = mean(silh_c);
end

[~, I] = max(cluster_means(:,2));
%idx_max = kmeans(data, cluster_range(I),'Display','final','Replicates',100);
%[silh, h] = silhouette(data, idx_max);

disp(['Highest cluster mean is with ',num2str(cluster_means(I,1)),' clusters.']);