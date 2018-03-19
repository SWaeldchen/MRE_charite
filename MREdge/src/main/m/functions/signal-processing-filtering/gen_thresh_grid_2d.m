function v = gen_thresh_grid_2d(u, thresh_pts, thresh_max, thresh_vals)

HIGH_VAL = 20;

sz = size(u);
mids = floor(sz/2);
max_rad = sqrt(mids(1)^2 + mids(2)^2);

pts = [1 thresh_pts thresh_max] ./ thresh_max * max_rad;
vals = [HIGH_VAL thresh_vals thresh_vals(end)];
vq = interp1(pts, vals, 1:1:max_rad, 'pchip');


[x, y] = meshgrid((1:sz(2)) - mids(2), (1:sz(1)) - mids(1));
ellipse_norm = min(ceil(sqrt(x.^2/mids(2)^2 + y.^2/mids(1)^2) * max_rad), floor(max_rad));
ellipse_norm = max(ellipse_norm, 1);
v = zeros(size(ellipse_norm));
for i = 1:sz(1)
    for j = 1:sz(2)
        v(i,j) = vq(ellipse_norm(i,j));
    end
end

