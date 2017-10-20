function u_den = dtdenoise_3d_mad_ogs_undec(u, fac, J, mask)

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

    xr = DT_OGS_u(xr, k, fac, J, mask);
    xi = DT_OGS_u(xi, k, fac, J, mask);
    
    u_den_vol = xr + 1i*xi;
    
	u_den(:,:,:,n) = simplecrop(u_den_vol, szu);
   
end
