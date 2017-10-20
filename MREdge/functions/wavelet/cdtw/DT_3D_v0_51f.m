function y = DT_3D_v0_51f(x)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding
y = zeros(size(x));

for n = 1:size(x, 4)
    
	xr = real(x(:,:,:,n));
	xi = imag(x(:,:,:,n));
    
    z_noise_r = z_noise_est(xr);
    zfac_r = 2 + (1 + z_noise_r );
    %zfac_r = 3;
    %display(['Z noise estimate real is ',num2str(z_noise_r), ' zfac is ', num2str(zfac_r)]);
    
    z_noise_i = z_noise_est(xi);
    zfac_i = 2 + (1 + z_noise_i );
    %zfac_i = 3;
    %display(['Z noise estimate imag is ',num2str(z_noise_i), ' zfac is ', num2str(zfac_i)]);
  
	sz = size(xr);

	[xr, order_vector] = dtdenoise_z_nocrop(xr, zfac_r);
	[xi, ~] = dtdenoise_z_nocrop(xi, zfac_i);
      
    sigma_r_vec = [];
    sigma_i_vec = [];
    for p = 1:size(xr,3)
		slc_r = xr(:,:,p);
		slc_i = xi(:,:,p);
		slc_r(isnan(slc_r)) = 0;
		slc_i(isnan(slc_i)) = 0;
        sigma_r_vec = cat(1, sigma_r_vec, NLEstimate(middle_square(slc_r)));
        sigma_i_vec = cat(1, sigma_i_vec, NLEstimate(middle_square(slc_i)));
    end
   
    sigma_r = mean(sigma_r_vec);
    sigma_i = mean(sigma_i_vec);
    
    lambda_r = 5*(sigma_r);
    lambda_i = 5*(sigma_i);

    %lambda_r = sigma_r;
    %lambda_i = sigma_i;
 
 
	sz2 = size(xr);
	pwr2_y = nextpwr2(sz2(1));
	pwr2_x = nextpwr2(sz2(2));
	pwr2_z = nextpwr2(sz2(3));

	pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
	pad_vec = [pwrmax, pwrmax, pwrmax];
	xr_pad = simplepad(xr, pad_vec);
	xi_pad = simplepad(xi, pad_vec);

	k = [3 3 3];
	shifts = 1;
	xr_pad_spin = zeros(size(xr_pad));
	xi_pad_spin = zeros(size(xi_pad));
	for xJig = 0:shifts-1
		for yJig = 0:shifts-1
			for zJig = 0:shifts-1
				display([num2str(xJig), ' ', num2str(yJig), ' ', num2str(zJig)]);
				%xr_pad_temp = DT_OGS(circshift(xr_pad, [xJig yJig zJig]), k, lambda_r, 4);
				%xi_pad_temp = DT_OGS(circshift(xi_pad, [xJig yJig zJig]), k, lambda_i);
				xr_pad_temp = DT_SOFT(circshift(xr_pad, [xJig yJig zJig]), lambda_r);
				xi_pad_temp = DT_SOFT(circshift(xi_pad, [xJig yJig zJig]), lambda_i);
				xr_pad_spin = xr_pad_spin + circshift(xr_pad_temp, [-xJig -yJig -zJig]);
				xi_pad_spin = xi_pad_spin + circshift(xi_pad_temp, [-xJig -yJig -zJig]);		
			end
		end
	end

	xr = xr_pad_spin(1:sz2(1), 1:sz2(2), 1:sz2(3));
	xi = xi_pad_spin(1:sz2(1), 1:sz2(2), 1:sz2(3));

	firsts = find(order_vector==1);
	index1 = firsts(1);
	index2 = index1 + sz(3) - 1;
	xr = xr(:,:,index1:index2);
	xi = xi(:,:,index1:index2);

	y(:,:,:,n) = xr + 1i*xi;
    
	assignin('base', 'xr_pad', xr_pad);
end
