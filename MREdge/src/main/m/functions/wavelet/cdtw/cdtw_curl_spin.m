function [xc, yc, zc] = cdtw_curl_spin(x, y, z, J)
    
	xc = zeros(size(x));
	yc = zeros(size(y));
	zc = zeros(size(z));
	display('jiggering');
	shifts = 2;
	tic
	for xJig = 0:shifts-1
		for yJig = 0:shifts-1
			for zJig = 0:shifts-1
				display([num2str(xJig), ' ', num2str(yJig), ' ', num2str(zJig)]);
				[xdx, xdy, xdz] = cdwt_diff_3D(circshift(x, [xJig yJig zJig]), J);
				[ydx, ydy, ydz] = cdwt_diff_3D(circshift(y, [xJig yJig zJig]), J);
				[zdx, zdy, zdz] = cdwt_diff_3D(circshift(z, [xJig yJig zJig]), J);
				xc = xc + circshift(zdy - ydz, [-xJig -yJig -zJig]);
				yc = yc + circshift(xdz - zdx, [-xJig -yJig -zJig]);
				zc = zc + circshift(ydx - xdy, [-xJig -yJig -zJig]);
			end
		end
	end
	toc
	xc = xc / 64;
	yc = yc / 64;
	zc = zc / 64;
end
