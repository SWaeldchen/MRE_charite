function g = middle_circle_tight(f)

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
	eighth_y = round(sz(1)/8);
	eighth_x = round(sz(2)/8);
	[x, y] = meshgrid(1:sz(2), 1:sz(1));
	g = (y - midpt_y).^2 ./ eighth_y^2 + (x - midpt_x).^2 / eighth_x^2 <= 1;
end

function g = middle_circle_3d(f)

	sz = size(f);
	midpt_y = round(sz(1)/2);
	midpt_x = round(sz(2)/2);
	midpt_z = round(sz(3)/2);
	eighth_y = round(sz(1)/8);
	eighth_x = round(sz(2)/8);
	eighth_z = round(sz(3)/8);
	[x, y, z] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3));
	g = (x - midpt_y).^2 ./ eighth_y^2 + ...
        (y - midpt_x).^2 / eighth_x^2 + ...
        (z - midpt_z).^2 ./ eighth_z^2 <= 1;
end
	
