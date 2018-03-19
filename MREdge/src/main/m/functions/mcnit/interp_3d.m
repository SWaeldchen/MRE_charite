function y = interp_3d(x, factor, method, polar, niter)
% y = interp_3d
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% 3 dimension interpolation of nd and complex objects.
% Makes for simple usage consisting of just an nd object
% and a resizing factor. Accommodates iterative interpolation,
% and polar-representation interpolation of complex numbers.
%
% INPUTS:
%
% x - 3 or higher dimensional object
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

if nargin < 2 || ndims(x) < 3
	disp('MCNIT error: interp_3d requires a 3d or higher data set, and an interpolation factor.');
end

sz = size(x);
[x_resh, n_vols] = resh(x, 4);
sz_interp = sz(1:3)*factor - (factor-1);
x_interp = zeros(sz_interp(1), sz_interp(2), sz_interp(3), n_vols);

for n = 1:n_vols
	x_resh(:,:,:,n) = interp_vol(x_resh(:,:,:,n), factor, method, polar, niter);
end

y = reshape(x_resh, [sz_interp(1), sz_interp(2), sz_interp(3), sz(4:end)]);

end

function y = interp_vol(x, factor, method, polar, niter)
	increment = factor .^ (1 / niter);
	for n = 1:niter
		old_rowspace = linspace(1, size(x,1), size(x,1));
		old_colspace = linspace(1, size(x,2), size(x,2));
		old_depth = linspace(1, size(x,3), size(x, 3));
		[x_old, y_old, z_old] = meshgrid(old_colspace, old_rowspace, old_depth);
		new_rowspace = linspace(1, size(x,1), size(x,1)*increment);
		new_colspace = linspace(1, size(x,2), size(x,2)*increment);
		new_depth = linspace(1, size(x,3), size(x,3)*increment);
		[x_new, y_new, z_new] = meshgrid(new_colspace, new_rowspace, new_depth);
		if iscomplex(x)
			if polar == 0
				y_re = interp3(x_old, y_old, z_old, real(x), x_new, y_new, z_new, method);
				y_im = interp3(x_old, y_old, z_old, imag(x), x_new, y_new, z_new, method);
				y = y_re + 1i*y_im;
			else
				[~, r] = cart2pol(x_re, x_im);
				r = interp3(x_old, y_old, z_old, x, x_new, y_new, z_new, method);
				t_re = interp3(x_old, y_old, z_old, x_re, x_new, y_new, z_new, method);
				t_im = interp3(x_old, y_old, z_old, x_im, x_new, y_new, z_new, method);
				t = angle(t_re + 1i*t_im);
				[y_re, y_im] = pol2cart(t, r);
				y = y_re + 1i*y_im;
			end
		else
			x = interp3(x_old, y_old, z_old, x, x_new, y_new, z_new, method);
		end
	end
end	
	
