function x = cubic_interp_3d(x, fac)

for i = 1:3
	sz = size(x);
	x_temp = zeros(round(sz(1)*fac), sz(2), sz(3));
	for j = 1:sz(3)
		resize_params = [round(sz(1)*fac) sz(2)];
        x_temp_r = real(x(:,:,j));
        x_temp_i = imag(x(:,:,j));
        %[x_temp_r, max_r, min_r] = normalize_image(real(x(:,:,j)));
        %[x_temp_i, max_i, min_i] = normalize_image(imag(x(:,:,j)));
        %x_resize_r = denormalize_image(double(imresize(uint16(x_temp_r*65535), resize_params)), max_r, min_r);
        %x_resize_i = denormalize_image(double(imresize(uint16(x_temp_i*65535), resize_params)), max_i, min_i);
        x_rows = rows(x_temp_r);
        new_rowspace = linspace(1, x_rows, x_rows*fac);
        x_resize_r = interp2(new_rowspace, 1:columns(x_rows), x_temp_r);
        x_resize_i = interp2(new_rowspace, 1:columns(x_rows), x_temp_i);
		x_temp(:,:,j) = x_resize_r + 1i*x_resize_i;
	end
	x = shiftdim(x_temp, 1);
end
