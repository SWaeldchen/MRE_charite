function [rer] = voxelwise_freqinfo_3(x);
tic

sz = size(x);
if (sz(3) < 10)
	x = cat(3, x, x);
	sz = size(x);
end
rer = zeros(sz);
for i = 16:sz(1)-16
	for j = 16:sz(2)-16
		for k = 1:sz(3)-8

			dct_cube = dct3d(x(i:i+7, j:j+7, k:k+7));
			denom = dct_cube(1,1,1).^2;
			red_num = dct_cube(2:5,2:5,2:5).^2;
			rer(i,j,k) = sum(red_num(:)) ./ denom;
		end
	end
end

toc
