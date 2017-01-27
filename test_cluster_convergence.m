function cm1 = test_cluster_convergence(data, cluster_range)

cm1 = test_clusters(data, cluster_range);
cm2 = test_clusters(data, cluster_range);

if cumsum(cm1(:,2)-cm2(:,2)) == 0
    display('convergence');
else
    display('kein convergence');
end