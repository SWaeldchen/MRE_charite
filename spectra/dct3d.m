function y = dct3d(x)
	sz = size(x);
	y = zeros(sz);
	for s = 1:sz(3)
		y(:,:,s) = dct(x(:,:,s));
	end
	y = shiftdim(y,1);
	for s = 1:sz(1)
		y(:,:,s) = dct(y(:,:,s));
	end
	y = shiftdim(y,1);
	for s = 1:sz(2)
		y(:,:,s) = dct(y(:,:,s));
	end
	y = shiftdim(y,1);
