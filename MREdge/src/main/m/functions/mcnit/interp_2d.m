function y = interp_2d(x, factor, method, polar, niter)
% y = interp_2d(x, factor, method, polar, niter)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% 2 dimension interpolation of nd and complex objects.
% Makes for simple usage consisting of just an nd object
% and a resizing factor. Accommodates iterative interpolation,
% and polar-representation interpolation of complex numbers.
%
% INPUTS:
%
% x - 2 or higher dimensional object
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

if nargin < 2 || ndims(x) < 2
	disp('MCNIT error: interp_2d requires a 2d or higher data set, and an interpolation factor.');
end

sz = size(x);
[x_resh, n_slcs] = resh(x, 3);
sz_interp = sz(1:2)*factor;
x_interp = zeros(sz_interp(1), sz_interp(2), n_slcs);

for n = 1:n_slcs
	x_interp(:,:,n) = interp_slc(x_resh(:,:,n), factor, method, polar, niter);
end

y = reshape(x_interp, [sz_interp(1), sz_interp(2), sz(3:end)]);

end

function y = interp_slc(x, factor, method, polar, niter)
	increment = factor .^ (1 / niter);
	for n = 1:niter
		old_rowspace = linspace(1, size(x,1), size(x,1));
		old_colspace = linspace(1, size(x,2), size(x,2));
		[x_old, y_old] = meshgrid(old_colspace, old_rowspace);
		new_rowspace = linspace(1, size(x,1), size(x,1)*increment);
		new_colspace = linspace(1, size(x,2), size(x,2)*increment);
		[x_new, y_new] = meshgrid(new_colspace, new_rowspace);
		if ~isreal(x)
			if polar == 0
				y_re = interp2(x_old, y_old, real(x), x_new, y_new, method);
				y_im = interp2(x_old, y_old, imag(x), x_new, y_new, method);
				y = y_re + 1i*y_im;
            else
                x_re = real(x);
                x_im = imag(x);
				[~, r] = cart2pol(x_re, x_im);
				r = interp2(x_old, y_old, x, x_new, y_new, method);
				t_re = interp2(x_old, y_old, x_re, x_new, y_new, method);
				t_im = interp2(x_old, y_old, x_im, x_new, y_new, method);
				t = angle(t_re + 1i*t_im);
				[y_re, y_im] = pol2cart(t, r);
				y = y_re + 1i*y_im;
			end
		else
			y = interp2(x_old, y_old, x, x_new, y_new, method);
		end
	end
end	
	
