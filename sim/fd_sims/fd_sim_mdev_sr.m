function [abs_G, u, lap_u] = fd_sim_mdev_sr(map)

if nargin == 0
    map = ones(400,400);
    map(298:302, 298:302) = 2;
end


k = [0.5:0.05:0.75];
nk = numel(k);
u = cell(nk);
lap_u = cell(nk);
absg_num = [];
absg_denom  = [];
down_fac = 4;
down_fac_root = down_fac.^(0.1);
for n = 1:nk
    u_full = normalize_image(fd_sim_2d(k(n), map));
    u_down = imresize(u_full, 1/down_fac);
    u{n} = iterative_increase(u_down, 10, down_fac_root, 0);
    lap_u{n} = lap(u{n});
    if n == 1
        absg_num = (2*pi/k(n)).^2.*abs(u{n});
        absg_denom = abs(lap_u{n});
    else
        absg_num = absg_num + (2*pi/k(n)).^2.*abs(u{n});
        absg_denom = absg_denom + abs(lap_u{n});
    end
end
abs_G = absg_num ./ absg_denom;