function x = interp_3d(x, fac);

for n = 1:3
	sz = size(x);
	x = imresize(x, [round(sz(1)*fac) sz(2)]);
	x = shiftdim(x, 1);
end	
