
function UI = MRE_interp_java(U, super_factor, interp_meth)
    if super_factor == 1
        UI = U;
        return
    end
    sz = size(U);
    if numel(sz) == 3
        d4 = 1;
    end
    UI = zeros(sz(1)*super_factor-super_factor+1, sz(2)*super_factor-super_factor+1, sz(3)*super_factor-super_factor+1);
	switch interp_meth
		case 1 % polar linear
			for n = 1:d4
                %for p = 1:sz(3)
                    res = inter2cplx(com.ericbarnhill.ESP.LinearPolarInterpolation.linearPolarInterpolate(cplx2inter(U(:,:,:,n)), super_factor));   % for debugging
					assignin('base', 'res', res);
				    UI(:,:,:,n) = res;
                %end
			end
		case 2 % polar spline
			for n = 1:d4
				for p = 1:sz(3)
				     UI(:,:,p,n) = polar_spline_interp(U(:,:,p,n), super_factor);                
                end
			end
		case 3 % complex spline
			for n = 1:d4
                for p = 1:sz(3)
				     UI(:,:,p,n) = complex_spline_interp(U(:,:,p,n), super_factor);                
                end
			end
		case 4 % wavelet guided
			for n = 1:d4
                parfor p = 1:sz(3)
                    slice = U(:,:,p,n);
				    UI(:,:,p,n) = wavelet_guided_interp_2d(slice, super_factor, 0.5*getLambda(slice));                
                end
			end
	end
end


