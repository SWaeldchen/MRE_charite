function [y, filt] = butter_3d(ord, cut, x, hi)
% y = butter_3d(ord, cut, x)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% 3 dimensional Butterworth filtering of nd and complex objects.
%
% INPUTS:
%
% ord - filter order
%
% cut - normalized frequency cut-off (between 0 and 1);
%
% x - 3 or higher dimensional object
%
% hi - set to 1 for hipass instead of lowpass
%
% OUTPUTS:
%
% y - object interpolated along three dimensions
%
% filt - copy of the filter

if nargin < 4
	hi = 0;
end
if nargin < 3 || cut < 0 || cut > 1 || ndims(x) < 3
	disp('MCNIT error: butter_3d must have 3+d data, cutoff between 0 and 1, and parameters for order and cutoff');
end

sz = size(x);
[x_resh, n_vols] = resh(x, 4);

for n = 1:n_vols
	[x_resh(:,:,:,n), filt] = filt_vol(ord, cut, x_resh(:,:,:,n), hi);
end

y = reshape(x_resh, sz);

end

function [y, filt] = filt_vol(ord, cut, x_vol, hi)
	sz = size(x_vol);
	mids = floor(sz/2) + 1;
	[x, y, z] = meshgrid( (1:sz(2)) - mids(2), (1:sz(1)) - mids(1), (1:sz(3)) - mids(3));
	w = sqrt(x.^2 + y.^2 + z.^2);
	w = w ./ max(w(:));
	w = w / cut;
	filt = sqrt(1 ./ (1 + w.^(2*ord)));
	if hi == 1
		filt = 1 - filt;
	end
	x_ft = fftshift(fftn(x_vol));
	x_filt = x_ft .* filt;
	y = ifftn(ifftshift(x_filt));
end	
	
