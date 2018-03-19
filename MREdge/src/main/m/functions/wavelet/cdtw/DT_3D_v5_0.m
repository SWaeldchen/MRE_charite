function y = DT_3D_v5_0(x, zfac, lambda)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding
y = zeros(size(x));
for n = 1:size(x, 4)
	xr = real(x(:,:,:,n));
	xi = imag(x(:,:,:,n));

	sz = size(xr);

	[xr, order_vector] = dtdenoise_z_nocrop(xr, zfac);
	[xi, ~] = dtdenoise_z_nocrop(xi, zfac);

	sz2 = size(xr);
	pwr2_y = nextpwr2(sz2(1));
	pwr2_x = nextpwr2(sz2(2));
	pwr2_z = nextpwr2(sz2(3));

	pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
	pad_vec = [pwrmax, pwrmax, pwrmax];
	xr_pad = simplepad(xr, pad_vec);
	xi_pad = simplepad(xi, pad_vec);

	k = [3 3 3];
	xr_pad = DT_OGS(xr_pad, k, lambda);
	xi_pad = DT_OGS(xi_pad, k, lambda);

	xr = xr_pad(1:sz2(1), 1:sz2(2), 1:sz2(3));
	xi = xi_pad(1:sz2(1), 1:sz2(2), 1:sz2(3));

	firsts = find(order_vector==1);
	index1 = firsts(1);
	index2 = index1 + sz(3) - 1;
	xr = xr(:,:,index1:index2,:,:);
	xi = xi(:,:,index1:index2,:,:);

	y(:,:,:,n) = xr + 1i*xi;
	assignin('base', 'xr_pad', xr_pad);
end
