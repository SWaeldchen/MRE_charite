function x = iterative_bicubic_3d(x, target, niter)
increment = target .^ (1 / niter);
sigma = increment/3;

for n = 1:niter
    for i = 1:3
	sz = size(x);
	x_temp = zeros(ceil(round(sz(1)*increment)), sz(2), sz(3));
	for j = 1:sz(3)
		resize_params = [ceil(round(sz(1)*increment)) sz(2)];
        x_temp_r = real(x(:,:,j));
        x_temp_i = imag(x(:,:,j));
        %[x_temp_r, max_r, min_r] = normalize_image(real(x(:,:,j)));
        %[x_temp_i, max_i, min_i] = normalize_image(imag(x(:,:,j)));
        %x_resize_r = denormalize_image(double(imresize(uint16(x_temp_r*65535), resize_params)), max_r, min_r);
        %x_resize_i = denormalize_image(double(imresize(uint16(x_temp_i*65535), resize_params)), max_i, min_i);
        x_rowspace = 1:rows(x_temp_r);
        x_colspace = 1:columns(x_temp_r);
        new_rowspace = linspace(1, rows(x_temp_r), ceil(rows(x_temp_r)*increment));
        [x_old y_old] = meshgrid(x_colspace, x_rowspace);
        [x_new y_new] = meshgrid(x_colspace, new_rowspace);
        size_check = [size(x_temp,1) size(x_temp,2)];
        x_resize_r = simplecrop(interp2(x_old, y_old, x_temp_r, x_new, y_new, 'pchip'), size_check);
        x_resize_i = simplecrop(interp2(x_old, y_old, x_temp_i, x_new, y_new, 'pchip'), size_check);
		x_temp(:,:,j) = x_resize_r + 1i*x_resize_i;
	end
	x = shiftdim(x_temp, 1);
    %d = max(3, ceil(increment));
    %x = smooth3_eb(x, 'gaussian', [d d d], sigma);
end

end