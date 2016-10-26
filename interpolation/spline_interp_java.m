function x_interp = spline_interp_java(x, factor)

interpolator = com.ericbarnhill.esp.Interpolator
len = numel(x);

if (isreal(x))
	x_interp = interpolator.interpSpline(x, factor);
else
	x_re = interpolator.interpLocalSpline(real(x), factor);
	x_im = interpolator.interpLocalSpline(imag(x), factor);
	x_interp = x_re + 1i*x_im;
end

end
