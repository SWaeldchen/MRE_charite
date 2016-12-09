function [mu, u, map] = fd_sim_sfwi

    map = ones(400,400);
    [x, y] = meshgrid(-199:200, -199:200);
    rad = sqrt(x.^2 + y.^2);
    circ_1 = rad <= 50;
    circ_2 = rad > 50 & rad <= 100;
    circ_3 = rad > 150;
    % map(circ_3) = 1.2;
    %map(circ_2) = 0.5;


k = [0.5:0.05:0.75];
nk = numel(k);
u = zeros(size(map,1), size(map,2), nk);

for n = 1:nk
    u(:,:,n) = fd_sim_2d(k(n), map);
end

mu = full_wave_inversion_2d(u, k, [.001 .001], 1, 1);