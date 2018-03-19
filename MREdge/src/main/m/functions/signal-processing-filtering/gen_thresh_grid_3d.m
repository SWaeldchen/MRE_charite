function [v, ellipse_norm] = gen_thresh_grid_3d(u, thresh_pts, thresh_vals)

BINS = 100;
%BINS_FULL = ceil(BINS*sqrt(3));
BINS_FULL = ceil(BINS*50);
HIGH_VAL = 50;

sz = size(u);
pts = cat(2, [0 thresh_pts] * BINS, BINS_FULL);
vals = [HIGH_VAL thresh_vals thresh_vals(end)];
vq = interp1(pts, vals, 1:1:BINS_FULL, 'pchip');

%centered meshgrid with normalized radius 1
%[x, y, z] = meshgrid( (1:sz(2)) / sz(2) * 2 - 1, (1:sz(1)) / sz(1) * 2 - 1, (1:sz(3)) / sz(3) * 2 - 1 );
[x, y, z] = meshgrid( (1:sz(2)) / sz(2) * 2 - 1, (1:sz(1)) / sz(1) * 2 - 1, (1:sz(3)) / sz(3) * 2 - 1 );

ellipse_norm = ceil(sqrt(x.^2 + y.^2 + z.^2)*BINS);
ellipse_norm = max(ellipse_norm, 1);
v = zeros(size(ellipse_norm));
for i = 1:sz(1)
    for j = 1:sz(2)
        for k = 1:sz(3)
            v(i,j,k) = vq(ellipse_norm(i,j,k));
        end
    end
end

ellipse_norm = ellipse_norm / BINS;
