function y = DT_3D_v0_52(x)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding
y = zeros(size(x));

for n = 1:size(x, 4)
    
	xr = real(x(:,:,:,n));
	xi = imag(x(:,:,:,n));
    
    z_noise_r = z_noise_est(xr);
    zfac_r = 2 + (1 + z_noise_r )^2;
    %zfac_r = 3;
    display(['Z noise estimate real is ',num2str(z_noise_r), ' zfac is ', num2str(zfac_r)]);
    
    z_noise_i = z_noise_est(xi);
    zfac_i = 2 + (1 + z_noise_i )^2;
    %zfac_i = 20;
    display(['Z noise estimate imag is ',num2str(z_noise_i), ' zfac is ', num2str(zfac_i)]);
  
	sz = size(xr);

	[xr, order_vector] = dtdenoise_z_nocrop(xr, zfac_r);
	[xi, ~] = dtdenoise_z_nocrop(xi, zfac_i);
      
    sigma_r_vec = [];
    sigma_i_vec = [];
    for p = 1:size(xr,3)
        sigma_r_vec = cat(1, sigma_r_vec, NLEstimate(middle_square(xr(:,:,p))));
        sigma_i_vec = cat(1, sigma_i_vec, NLEstimate(middle_square(xi(:,:,p))));
    end
   
    sigma_r = mean(sigma_r_vec)
    sigma_i = mean(sigma_i_vec)
    
    lambda_r = (0.5*sigma_r)
    lambda_i = (0.5*sigma_i)

    %lambda_r = (0.2*sigma_r)
    %lambda_i = (0.2*sigma_i)
 
 
	sz2 = size(xr);
	pwr2_y = nextpwr2(sz2(1));
	pwr2_x = nextpwr2(sz2(2));
	pwr2_z = nextpwr2(sz2(3));

	pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
	pad_vec = [pwrmax, pwrmax, pwrmax];
	xr_pad = simplepad(xr, pad_vec);
	xi_pad = simplepad(xi, pad_vec);

	k = [3 3 3];
	xr_pad = DT_OGS(xr_pad, k, lambda_r);
	xi_pad = DT_OGS(xi_pad, k, lambda_i);

	xr = xr_pad(1:sz2(1), 1:sz2(2), 1:sz2(3));
	xi = xi_pad(1:sz2(1), 1:sz2(2), 1:sz2(3));

	firsts = find(order_vector==1);
	index1 = firsts(1);
	index2 = index1 + sz(3) - 1;
	xr = xr(:,:,index1:index2);
	xi = xi(:,:,index1:index2);

	y(:,:,:,n) = xr + 1i*xi;
    
	assignin('base', 'xr_pad', xr_pad);
end
