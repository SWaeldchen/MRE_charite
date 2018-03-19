function [U_filt] = remove_grid_4d(U, super_factor, noZ)

sz = size(U);
U_filt = zeros(sz);
for n = 1:sz(4)
	U_filt(:,:,:,n)= remove_grid(U(:,:,:,n), super_factor, noZ);
end

