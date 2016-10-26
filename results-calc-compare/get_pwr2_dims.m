function [xy_dim, z_dim] = get_pwr2_dims(U)

sz = size(U);
pwr_z = 0;
while (2^pwr_z < sz(3))
    pwr_z = pwr_z+1;
end
z_dim = 2^(pwr_z+1);

pwr_xy = 0;
while (2^pwr_xy < max(sz(1), sz(2)))
    pwr_xy = pwr_xy+1;
end
xy_dim = 2^(pwr_xy);
