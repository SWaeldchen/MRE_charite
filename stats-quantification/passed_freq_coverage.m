function p = passed_freq_coverage(x)

sz = size(x);
slices = sz(3);
numel_area = numel(x(:,:,1));
p = 0;
for n = 1:slices
	x_pwr = normlogpwrspec(x(:,:,n));
	ratio = numel(x_pwr(x_pwr >= -5)) ./ numel_area;
	p = p + ratio;
end
p = p / slices;
