function [weights] = plot_eigenfreqs(x)

figure(); hold on;
obs = size(x,1);
weights = zeros(obs,1);
for n = 1:obs
    [comp, weight] = get_pca(x, n);
    plot(comp);
    weights(n) = weight;
end
display(weights)
hold off;