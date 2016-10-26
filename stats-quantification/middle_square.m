function g = middle_square(f)

	sz = size(f);
	if numel(sz) == 2
		g = middle_square_2d(f);
	elseif numel(sz) == 3
		g = middle_square_3d(f);
	else
		display('2d or 3d only, returning null');
		g = [];
	end

end

function g = middle_square_2d(f)

	sz = size(f);
	midpt_y = round(sz(1)/2);
	midpt_x = round(sz(2)/2);
	quarter_y = round(sz(1)/4);
	quarter_x = round(sz(2)/4);
	[x, y] = meshgrid((1:sz(1))-midpt_x, (1:sz(2))-midpt_y);
	g = zeros(midpt_y, midpt_x);
	g = f(quarter_y:quarter_y+midpt_y, quarter_x:quarter_x+midpt_x);
	
end

function g = middle_square_3d(f)

	sz = size(f);
	midpt_y = round(sz(1)/2);
	midpt_x = round(sz(2)/2);
	midpt_z = round(sz(3)/2);
	quarter_y = round(sz(1)/4);
	quarter_x = round(sz(2)/4);
	quarter_z = round(sz(3)/4);
	[x, y, z] = meshgrid((1:sz(1))-midpt_x, (1:sz(2))-midpt_y, (1:sz(3))-midpt_z);
	g = zeros(midpt_y, midpt_x, midpt_z);
	g = f(quarter_y:quarter_y+midpt_y, quarter_x:quarter_x+midpt_x, quarter_z:quarter_z+midpt_z);
	
end
