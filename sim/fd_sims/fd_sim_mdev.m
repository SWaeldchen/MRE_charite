function [abs_G, u, lap_u] = fd_sim_mdev(map)

if nargin == 0
    map = ones(400,400);
    map(298:302, 298:302) = 2;
end


k = [0.5:0.05:0.75];
nk = numel(k);
u = cell(nk);
lap_u = cell(nk);
absg_num = zeros(size(map));
absg_denom  = zeros(size(map));
for n = 1:nk
    u{n} = fd_sim_2d(k(n), map);
    lap_u{n} = lap(u{n});
    absg_num = absg_num + (2*pi/k(n)).^2.*abs(u{n});
    absg_denom = absg_denom + abs(lap_u{n});
end
abs_G = absg_num ./ absg_denom;