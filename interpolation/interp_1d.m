function y = interp_1d(x, factor, method, polar, niter)
% y = interp_1d(x, factor, method, polar, niter)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% 1 dimension interpolation of nd and complex objects.
% Makes for simple usage consisting of just an nd object
% and a resizing factor. Accommodates iterative interpolation,
% and polar-representation interpolation of complex numbers.
%
% INPUTS:
%
% x - 1 or higher dimensional object
%
% factor - interpolation factor
%
% method - interpolation method using an accepted GNU Octave (or Matlab) interpolation strategy 
%			such as 'linear', 'pchip', or 'spline
%
% polar - if data is complex, setting polar to nonzero will interpolate phase and magnitude 
%			rather than real and imagingary parts separately. zero or empty set will
%			produce default behavior (interpolation real and imaginary parts). Note that
%			GNU octave can have trouble handling empty arguments
%
% niter - only applicable for iterative spline interpolation. sets number of iterations
%
% OUTPUTS:
%
% y - object interpolated along three dimensions

if nargin < 5
	niter = 1;
	if nargin < 4
		polar = 0;
		if nargin < 3
			method = 'spline';
		end
	end
end

if nargin < 2 
	disp('MCNIT error: interp_1d requires an interpolation factor.');
end

sz = size(x);
[x_resh, n_lines] = resh(x, 2);
sz_interp = round(sz(1)*factor);
x_interp = zeros(sz_interp(1), n_lines);

for n = 1:n_lines
	x_interp(:,n) = interp_line(x_resh(:,n), factor, method, polar, niter);
end

y = reshape(x_interp, [sz_interp(1), sz(2:end)]);

end

function y = interp_line(x, factor, method, polar, niter)
	increment = factor .^ (1 / niter);
	for n = 1:niter
		x_old = linspace(1, size(x,1), size(x,1));
		x_new = linspace(1, size(x,1), round(size(x,1)*increment));
		if ~isreal(x)
			if polar == 0
				y_re = interp1(x_old, real(x), x_new, method, 'extrap');
				y_im = interp1(x_old, imag(x), x_new, method, 'extrap');
				y = y_re + 1i*y_im;
			else
				[~, r] = cart2pol(real(x), imag(x));
				r = interp1(x_old, r, x_new, method);
				t_re = interp1(x_old, real(x), x_new, method, 'extrap');
				t_im = interp1(x_old, imag(x), x_new, method, 'extrap');
				t = angle(t_re + 1i*t_im);
				[y_re, y_im] = pol2cart(t, r);
				y = y_re + 1i*y_im;
			end
		else
			x = interp2(x_old, x, x_new, method);
		end
	end
end	
	
