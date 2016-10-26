function x_interp = polar_interp(x, fac, meth, T1, T2)
    if nargin < 3
        meth = 1;
    end
    r = zeros(size(x));
    t = zeros(size(x));
    for n = 1:numel(x) %convert array
        [t_, r_] = cart2pol(real(x(n)), imag(x(n)));
        r(n) = r_;
        t(n) = t_;
    end
    t = unwrap(t);
    if meth == 1
        r_interp = linear_interp(r, fac);
        t_interp = linear_interp(t, fac);
    elseif meth == 2
        r_interp = resample(r, fac, 1);
        t_interp = resample(t, fac, 1);
    elseif meth == 3    
        r_interp = wavelet_guided_interp_1d(r, fac, T1);
        t_interp = wavelet_guided_interp_1d(t, fac, T2);
    elseif meth == 4
        r_interp = cdwt_interp_1d(r, fac);
        t_interp = cdwt_interp_1d(t, fac);
    elseif meth == 5
        r_interp = spline_interp(r, fac);
        t_interp = spline_interp(t, fac);
    end
    t_interp = wrap(t_interp);
    x_interp = zeros(size(r_interp));
	size(r_interp)
	size(t_interp)
    for n = 1:numel(x_interp)
        [re, im] = pol2cart(t_interp(n), r_interp(n));
        x_interp(n) = re + 1i*im;
    end
end

function y = wrap(x)
    y = mod(x, 2*pi);
end
