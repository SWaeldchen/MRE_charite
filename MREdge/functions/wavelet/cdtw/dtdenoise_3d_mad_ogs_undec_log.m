function u_den = dtdenoise_3d_mad_ogs_undec_log(u, fac, J, mask, fileID, base1, base2)

% 3D Dualtree complex denoising 
% with overlapping group sparsity thresholding
% also produces x y and z spatial derivatives

szu = size(u);
u_den = zeros(szu);
k = [3 3 3];
if numel(size(u)) < 4
    d4 = 1;
else
    d4 = size(u,4);
end
if nargin < 3
    mask = true(size(u));
end
mask = logical(mask);
for n = 1:d4
    
	xr = real(u(:,:,:,n));
	xi = imag(u(:,:,:,n));

    xr = DT_OGS_u_log(xr, k, fac, J, mask, fileID, base1, base2);
    xi = DT_OGS_u_log(xi, k, fac, J, mask, fileID, base1, base2);
    
    u_den_vol = xr + 1i*xi;
    
	u_den(:,:,:,n) = simplecrop(u_den_vol, szu);
   
end
