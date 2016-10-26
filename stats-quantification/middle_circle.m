function g = middle_circle(f)

	sz = size(f);
	if numel(sz) == 2
		g = middle_circle_2d(f);
	elseif numel(sz) == 3
		g = middle_circle_3d(f);
	else
		display('2d or 3d only, returning null');
		g = [];
	end

end

function g = middle_circle_2d(f)

	sz = size(f);
	midpt_y = round(sz(1)/2);
	midpt_x = round(sz(2)/2);
	quarter_y = round(sz(1)/4);
	quarter_x = round(sz(2)/4);
	[x, y] = meshgrid((1:sz(1))-midpt_y, (1:sz(2))-midpt_x);
	radius = sqrt(x.^2 + y.^2);
	cutoff_radius = sqrt(quarter_x^2 + quarter_y^2);
	g = nan(sz);
	g(radius < cutoff_radius) = f(radius < cutoff_radius);
	
end

function g = middle_circle_3d(f)

	sz = size(f);
	midpt_y = round(sz(1)/2);
	midpt_x = round(sz(2)/2);
	midpt_z = round(sz(3)/2);
	quarter_y = round(sz(1)/4);
	quarter_x = round(sz(2)/4);
	quarter_z = round(sz(3)/4);
	[x, y, z] = meshgrid((1:sz(2))-midpt_x, (1:sz(1))-midpt_y, (1:sz(3))-midpt_z);
	radius = sqrt(x.^2 + y.^2 + z.^2);
	cutoff_radius = sqrt(quarter_x^2 + quarter_y^2 + quarter_z^2);
	g = nan(sz);
	g(radius < cutoff_radius) = f(radius < cutoff_radius);
	
end
