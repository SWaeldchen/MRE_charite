function x_interp = cubic_interp_java(x, factor)

interpolator = com.ericbarnhill.esp.Interpolator
len = numel(x);

if (isreal(x))
	x_interp = interpolator.interpSpline(x, factor);
else
	x_re = interpolator.interpCubic(real(x), factor);
	x_im = interpolator.interpCubic(imag(x), factor);
	x_interp = x_re + 1i*x_im;
end

end
