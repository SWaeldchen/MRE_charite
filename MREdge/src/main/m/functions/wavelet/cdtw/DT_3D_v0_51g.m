function y = DT_3D_v0_51g(x, fac, cut)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding
y = zeros(size(x));
if numel(size(x)) < 4
    d4 = 1;
else
    d4 = size(x,4);
end

for n = 1:d4
    
	xr = real(x(:,:,:,n));
	xi = imag(x(:,:,:,n));
	sz = size(xr);

	%[xr, order_vector] = dtdenoise_z_auto_noise_est_nocrop(xr);
	%[xi, ~] = dtdenoise_z_auto_noise_est_nocrop(xi);
      
    mad_r = mad_est_3d(xr);
    mad_i = mad_est_3d(xi);
   	lambda_r = (fac*mad_r);
    lambda_i = (fac*mad_i);
 
 
	sz2 = size(xr);
	pwr2_y = nextpwr2(sz2(1));
	pwr2_x = nextpwr2(sz2(2));
	pwr2_z = nextpwr2(sz2(3));

	pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
	pad_vec = [pwrmax, pwrmax, pwrmax];
	xr_pad = simplepad(xr, pad_vec);
	xi_pad = simplepad(xi, pad_vec);

	k = [3 3 3];
	shifts = 4;
	xr_pad_spin = zeros(size(xr_pad));
	xi_pad_spin = zeros(size(xi_pad));
    den = tic;
	for xJig = 0:shifts-1
		for yJig = 0:shifts-1
			for zJig = 0:shifts-1
				display([num2str(xJig), ' ', num2str(yJig), ' ', num2str(zJig)]);
				xr_pad_temp = DT_OGS(circshift(xr_pad, [xJig yJig zJig]), k, lambda_r, 2);
				xi_pad_temp = DT_OGS(circshift(xi_pad, [xJig yJig zJig]), k, lambda_i, 2);
				%xr_pad_temp = DT_SOFT(circshift(xr_pad, [xJig yJig zJig]), lambda_r);
				%xi_pad_temp = DT_SOFT(circshift(xi_pad, [xJig yJig zJig]), lambda_i);
				xr_pad_spin = xr_pad_spin + circshift(xr_pad_temp, [-xJig -yJig -zJig]);
				xi_pad_spin = xi_pad_spin + circshift(xi_pad_temp, [-xJig -yJig -zJig]);		
			end
		end
	end
    disp('denoise complete');
    toc(den);
	xr = xr_pad_spin(1:sz2(1), 1:sz2(2), 1:sz2(3));
	xi = xi_pad_spin(1:sz2(1), 1:sz2(2), 1:sz2(3));

	firsts = find(order_vector==1);
	index1 = firsts(1);
	index2 = index1 + sz(3) - 1;
	xr = xr(:,:,index1:index2);
	xi = xi(:,:,index1:index2);

    den = xr + 1i*xi;
    %den = hipass_butter_3d(4, cut, den);
	y(:,:,:,n) = den;
    
end
