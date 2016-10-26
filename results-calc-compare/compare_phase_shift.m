function [montage, diffs] = compare_phase_shift(sl1, sl2);

mask = find(sl1 ~= 0);
suppress = find(sl1 == 0);
sl1_exp = exp(1i.*sl1);
sl2_exp = exp(1i.*sl2);
sz = size(sl1);

montage = [];
difs = zeros(100,1);

shifts = linspace(0, 2*pi);

for y = 1:10
	row = [];
	for x = 1:10
		shift_index = (y-1)*10 + x;
		sl2_shift = sl2_exp .* exp(1i.*shifts(shift_index));
		sl_diff = abs(angle(sl1_exp ./ sl2_shift));
		sl_diff(suppress) = nan;
		row = cat(2, row, sl_diff);
		diffs(shift_index) = mean(sl_diff(mask));
	end
	montage = cat(1, montage, row);
end
