function [xc, yc, zc, div] = dwt_curl(x, y, z, J)
    
    [xdxr, xdyr, xdzr] = dwt_diff_3D(real(x),J);
	[ydxr, ydyr, ydzr] = dwt_diff_3D(real(y),J);
	[zdxr, zdyr, zdzr] = dwt_diff_3D(real(z),J);
	xcr = zdyr - ydzr;
	ycr = xdzr - zdxr;
	zcr = ydxr - xdyr;
    
    [xdxi, xdyi, xdzi] = dwt_diff_3D(imag(x),J);
	[ydxi, ydyi, ydzi] = dwt_diff_3D(imag(y),J);
	[zdxi, zdyi, zdzi] = dwt_diff_3D(imag(z),J);
	xci = zdyi - ydzi;
	yci = xdzi - zdxi;
	zci = ydxi - xdyi;
    
    xc = xcr + 1i*xci;
    yc = ycr + 1i*yci;
    zc = zcr + 1i*zci;
    
    div = xdxr + ydyr + zdzr + 1i*xdxi + 1i*ydyi + 1i*zdzi;

end
