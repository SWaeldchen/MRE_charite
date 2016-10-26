function x_interp = akima_spline_interp(x, factor)

interpolator = com.ericbarnhill.esp.Interpolator
len = numel(x);

if (isreal(x))
	x_interp = interpolator.interpLocalAkima(x, factor);
else
	x_re = interpolator.interpLocalAkima(real(x), factor);
	x_im = interpolator.interpLocalAkima(imag(x), factor);
	x_interp = x_re + 1i*x_im;
end

end
