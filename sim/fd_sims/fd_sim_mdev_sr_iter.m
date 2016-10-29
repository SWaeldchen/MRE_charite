function [montage, g_byfreq, abs_G_orig, abs_G_down, abs_G_sr_iter, u, lap_u] = fd_sim_mdev_sr_iter(map)

if nargin == 0
    map = ones(400,400);
    map(298:302, 298:302) = 2;
end


k = 0.5:0.1:3;
nk = numel(k);
u = cell(nk);
lap_u = cell(nk);
down_fac = 4;
down_fac_root = down_fac.^(0.1);

absg_num_sr_iter = [];
absg_denom_sr_iter  = [];
absg_num_sr_bicub = [];
absg_denom_sr_bicub  = [];
absg_num_down = [];
absg_denom_down = [];
absg_num_orig = [];
absg_denom_orig = [];
g_byfreq = cell(nk);

for n = 1:nk    
    u_orig = normalize_image(fd_sim_2d(k(n), map));
    u_orig = u_orig + randn(size(u_orig))*.01;
    u_orig = DT_2D_spin(u_orig, 8, 0.1, 3);
    u_down = imresize(u_orig, 1/down_fac);
    u{n} = iterative_increase_gauss(u_down, 10, down_fac_root);
    u_bicub = imresize(u_down, down_fac);
    lap_u{n} = lap(u{n});
    lap_down = lap(u_down) / (down_fac)^2;
    lap_orig = lap(u_orig);
    lap_bicub = lap(u_bicub);
    g_byfreq{n} = ( (2*pi*k(n)).^2.*abs(u{n}) ) ./ abs(lap_u{n});
    if n == 1
        absg_num_sr_iter = (2*pi*k(n)).^2.*abs(u{n});
        absg_denom_sr_iter = abs(lap_u{n});
        absg_num_sr_bicub = (2*pi*k(n)).^2.*abs(u_bicub);
        absg_denom_sr_bicub = abs(lap_bicub);
        absg_num_down =  (2*pi*k(n)).^2.*abs(u_down);
        absg_denom_down =  abs(lap_down);
        absg_num_orig = (2*pi*k(n)).^2.*abs(u_orig);
        absg_denom_orig = abs(lap_orig);
    else
        absg_num_sr_iter = absg_num_sr_iter + (2*pi/k(n)).^2.*abs(u{n});
        absg_denom_sr_iter = absg_denom_sr_iter + abs(lap_u{n});
        absg_num_sr_bicub = absg_num_sr_bicub + (2*pi*k(n)).^2.*abs(u_bicub);
        absg_denom_sr_bicub = absg_denom_sr_bicub + abs(lap_bicub);
        absg_num_down =  absg_num_down + (2*pi/k(n)).^2.*abs(u_down);
        absg_denom_down =  absg_denom_down + abs(lap_down);
        absg_num_orig = absg_num_orig + (2*pi/k(n)).^2.*abs(u_orig);
        absg_denom_orig = absg_denom_orig + abs(lap_orig);
    end
end
abs_G_sr_iter = absg_num_sr_iter ./ absg_denom_sr_iter;
abs_G_sr_bicub = simplepad(absg_num_sr_bicub ./ absg_denom_sr_bicub,  size(abs_G_sr_iter));
abs_G_down = imresize(absg_num_down ./ absg_denom_down, size(abs_G_sr_iter));
abs_G_orig = simplepad(absg_num_orig ./ absg_denom_orig, size(abs_G_sr_iter));
montage = cat(2, abs_G_orig, abs_G_down, abs_G_sr_bicub./4, abs_G_sr_iter);