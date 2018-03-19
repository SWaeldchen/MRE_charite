function [xc, yc, zc] = cdwt_curl(x, y, z, J)
    
	[xdxr, xdyr, xdzr] = cdwt_diff_3D(real(x),J);
	[ydxr, ydyr, ydzr] = cdwt_diff_3D(real(y),J);
	[zdxr, zdyr, zdzr] = cdwt_diff_3D(real(z),J);
	xcr = zdyr - ydzr;
	ycr = xdzr - zdxr;
	zcr = ydxr - xdyr;
    
    [xdxi, xdyi, xdzi] = cdwt_diff_3D(imag(x),J);
	[ydxi, ydyi, ydzi] = cdwt_diff_3D(imag(y),J);
	[zdxi, zdyi, zdzi] = cdwt_diff_3D(imag(z),J);
	xci = zdyi - ydzi;
	yci = xdzi - zdxi;
	zci = ydxi - xdyi;
    
    xc = xcr + 1i*xci;
    yc = ycr + 1i*yci;
    zc = zcr + 1i*zci;

end
