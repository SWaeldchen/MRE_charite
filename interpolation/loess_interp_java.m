function x_interp = loess_interp_java(x, factor)

interpolator = com.ericbarnhill.esp.Interpolator
len = numel(x);
%weights = 1./ abs(lap(x)).^2;
weights = ones(size(x));
band = 0.8;
iter = 4;
if (isreal(x))
	x_interp = interpolator.interpHermite(x, factor);
else
	x_re = interpolator.interpLoess(real(x), factor);
	x_im = interpolator.interpLoess(imag(x), factor);
	x_interp = x_re + 1i*x_im;
end

end
