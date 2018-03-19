function u_den = dtdenoise_3d_asg(u, J, mask)

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
    mask = ones(size(u));
end

for n = 1:d4
    
    amp = abs(u(:,:,:,n));
    %amp = ones(size(u(:,:,:,n)));
	xr = real(u(:,:,:,n));    
	xi = imag(u(:,:,:,n));  
	sz = size(xr);
    
    xr = DT_ASG_u(xr, J, mask, amp);
    xi = DT_ASG_u(xi, J, mask, amp);
    
    u_den_vol = xr + 1i*xi;
    
	u_den(:,:,:,n) = simplecrop(u_den_vol, szu);
   
end
