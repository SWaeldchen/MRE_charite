function bins = passed_freq_coverage_bins(x)

sz = size(x);
ctr_pts = round(sz/2);
[x y z] = meshgrid((1:sz(2)) - ctr_pts(2), (1:sz(1)) - ctr_pts(1), (1:sz(3)) - ctr_pts(3));
radius = round( (x.^2 + y.^2 + z.^2) / 100);
assignin('base', 'radius', radius);
bins = zeros(max(radius(:))+1, 1);
size(bins)
x_spec = abs(pwrspec(x));
for i = 1:sz(1)
	for j = 1:sz(2)
		for k = 1:sz(3)
			bin = radius(i,j,k) + 1;
			bins(bin) = bins(bin) + x_spec(i,j,k);
		end
	end
end

