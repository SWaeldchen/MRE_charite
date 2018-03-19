function u_den, u_x, u_y, u_z] = dtdenoise_3d_mad_ogs_undec(u, fac)

% 3D Dualtree complex denoising 
% with overlapping group sparsity thresholding
% also produces x y and z spatial derivatives

szu = size(u);
u_den = zeros(szu);
u_x = zeros(szu);
u_y = zeros(szu);
u_z = zeros(szu);
k = [3 3 3];
if numel(size(u)) < 4
    d4 = 1;
else
    d4 = size(u,4);
end


for n = 1:d4
    
	xr = real(u(:,:,:,n));
	xi = imag(u(:,:,:,n));
	sz = size(xr);

    mad_r = mad_est_3d(xr);
    mad_i = mad_est_3d(xi);
   	lambda_r = (fac*mad_r);
    lambda_i = (fac*mad_i);
 
    [xr, xr_x, xr_y, xr_z] = DT_OGS_u(xr, k, lambda_r, 3);
    [xi, xi_x, xi_y, xi_z] = DT_OGS_u(xi, k, lambda_i, 3);
    
    u_den_vol = xr + 1i*xi;
    u_den_x = xr_x + 1i*xi_x;
    u_den_y = xr_y + 1i*xi_y;
    u_den_z = xr_z + 1i*xi_z;
    
	u_den(:,:,:,n) = simplecrop(u_den_vol, szu);
    u_x(:,:,:,n) = simplecrop(u_den_x, szu);
    u_y(:,:,:,n) = simplecrop(u_den_y, szu);
    u_z(:,:,:,n) = simplecrop(u_den_z, szu);
    
end
