function [er, ent, rer, rent] = voxelwise_freqinfo(x);
tic
sz = size(x);
er = zeros(sz);
ent = zeros(sz);
rer = zeros(sz);
rent = zeros(sz);
for i = 1:sz(1)-8
	for j = 1:sz(2)-8
		for k = 1:sz(3)-8

			dct_cube = dct3d(x(i:i+7, j:j+7, k:k+7));
			ent(i,j,k) = entropy(normalise(dct_cube));
			rent(i,j,k) = entropy(normalise(dct_cube(1:3,1:3,1:3)));
			num = dct_cube(2:end,2:end,2:end).^2;
			denom = dct_cube(1,1,1).^2;
			red_num = dct_cube(2:5,2:5,2:5).^2;
			er(i,j,k) = sum(num(:)) / denom;
			rer(i,j,k) = sum(red_num(:)) / denom;
		end
	end
end

toc
