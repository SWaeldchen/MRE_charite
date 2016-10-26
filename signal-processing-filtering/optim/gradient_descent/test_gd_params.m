iters = [500 1000];
lambdas = [0.1 0.2];
epsilons = [0.001, 0.005, 0.01];
n_it = numel(iters);
n_lam = numel(lambdas);
n_eps = numel(epsilons);

ims = cell(n_it, n_lam, n_eps);
h = figure('color', 'w');
for i = 1:n_it
    for j = 1:n_lam
        for k = 1:n_eps
            ims{i,j,k} = eb_gd(onion_noise_norm, iters(i), lambdas(j), epsilons(k));
            figure(h);
            index = (i-1)*n_lam*n_eps + (j-1)*n_eps + k;
            subplot(n_it, n_lam*n_eps, index);
            imshow(ims{i,j,k}, []);
            title([num2str(iters(i)), ' ', num2str(lambdas(j)), ' ', num2str(epsilons(k))]);
        end
    end
end
        
       