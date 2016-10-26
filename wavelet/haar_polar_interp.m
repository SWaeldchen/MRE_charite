function x_interp = haar_polar_interp(x, fac)
    r = zeros(size(x));
    t = zeros(size(x));
    for n = 1:numel(x) %convert array
        [t_, r_] = cart2pol(real(x(n)), imag(x(n)));
        r(n) = r_;
        t(n) = t_;
    end
    t = unwrap(t);
    r_interp = haar_interp_1d(r, fac);
    t_interp = haar_interp_1d(t, fac);
    t_interp = wrap(t_interp);
    x_interp = zeros(size(r_interp));
    for n = 1:numel(x_interp)
        [re, im] = pol2cart(t_interp(n), r_interp(n));
        x_interp(n) = re + 1i*im;
    end
end

function y = wrap(x)
    y = mod(x, 2*pi);
end