lambda = 2.^[4, 5, 6, 7, 8];
full_length = 2048;
disp_length = 512;
valid_length = full_length - 2;
half_length = full_length/2;
half_disp_length = disp_length / 2;
xlims = [half_length - disp_length, half_length + disp_length];
ylims = [5 7];
n_lambda = numel(lambda);
close all;
c = colormap(jet(n_lambda*2));
u = zeros(full_length, n_lambda);
lapu = zeros(valid_length, n_lambda);
k_helm = zeros(valid_length, n_lambda);
k_pg = zeros(valid_length, n_lambda);
[b, a] = butter(4, 0.5);
for l = 1:numel(lambda)
    u(:,l) = filter(b, a, hilbert(sinVec(full_length, lambda(l))));
    lapu(:,l) = conv(u(:,l), [1 -2 1], 'valid');
    k_helm(:,l) = sqrt(-lapu(:,l)./u(2:end-1,l)) * lambda(l);
    k_pg(:,l) = conv(unwrap(angle(u(:,l))), [1 0 -1]/2, 'valid') * lambda(l);
end

figure(1); hold off;
plot(1:valid_length, real(k_helm)); hold on; 
plot(1:valid_length,k_pg, '--'); ylim(ylims); xlim(xlims);
%figure(2); complexPlot(u(:,3)); xlim(xlims);
%figure(3); complexPlot(lapu(:,3)); xlim(xlims);
%figure(4); plot(k_pg(:,3)); xlim(xlims);