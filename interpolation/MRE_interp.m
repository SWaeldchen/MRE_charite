
function UI = MRE_interp(U, superFactor, interp_meth)
    sz = size(U);
    UI = zeros(sz(1)*superFactor, sz(2)*superFactor, sz(3), sz(4));
	thresh = 800;
	switch interp_meth
		case 1 % polar linear
			for n = 1:sz(4)
                for p = 1:sz(3)
				     UI(:,:,p,n) = polar_linear_interp(U(:,:,p,n), superFactor);   
                end
			end
		case 2 % polar spline
			for n = 1:sz(4)
				for p = 1:sz(3)
				     UI(:,:,p,n) = polar_spline_interp(U(:,:,p,n), superFactor);                
                end
			end
		case 3 % complex spline
			for n = 1:sz(4)
                for p = 1:sz(3)
				     UI(:,:,p,n) = complex_spline_interp(U(:,:,p,n), superFactor);                
                end
			end
		case 4 % wavelet guided
			for n = 1:sz(4)
                parfor p = 1:sz(3)
                    slice = U(:,:,p,n);
				    UI(:,:,p,n) = wavelet_guided_interp_2d(slice, superFactor, 0.5*getLambda(slice));                
                end
			end
	end
end


