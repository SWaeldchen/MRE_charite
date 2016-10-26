function [montage] = FEM_montage(fem_cslc)

sz = size(fem_cslc);

montage = [];

for n = 1:sz(3)
	montage = cat(2, montage, permute(fem_cslc(:,:,n), [2 1]));
end
