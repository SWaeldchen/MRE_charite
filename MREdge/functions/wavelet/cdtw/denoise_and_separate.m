function [u_lo, u_hi] = denoise_and_separate(u, fac, J, mask)

% 3D Dualtree complex denoising 
% with overlapping group sparsity thresholding
% also produces x y and z spatial derivatives

szu = size(u);
u_lo = zeros(szu);
u_hi = zeros(szu);
k = [3 3 3];
if numel(size(u)) < 4
    d4 = 1;
else
    d4 = size(u,4);
end
if nargin < 3
    mask = ones(size(u));
end

for n = 1:d4
    
	xr = real(u(:,:,:,n));
	xi = imag(u(:,:,:,n));

    mad_r = sigma_mad_wavelet(xr, mask);
    mad_i = sigma_mad_wavelet(xi, mask);
   	lambda_r = (fac*mad_r);
    lambda_i = (fac*mad_i);
 
    [xr_lo, xr_hi] = denoise_separate_volume(xr, k, lambda_r, J);
    [xi_lo, xi_hi] = denoise_separate_volume(xi, k, lambda_i, J);
    
    u_lo(:,:,:,n) = xr_lo + 1i*xi_lo;
    u_hi(:,:,:,n) = xr_hi + 1i*xi_hi;
       
end
