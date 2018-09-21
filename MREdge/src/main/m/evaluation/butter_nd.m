function [y, filt] = butter_nd(x, filt_dimsord, cut, x, hi)
% y = butter_nd(ord, cut, x)
% DESCRIPTION:
%
% n-dim dimensional Butterworth filtering of nd and complex objects.
%
% INPUTS:
%
% ord - filter order
%
% cut - normalized frequency cut-off (between 0 and 1);
%
% x - 2 or higher dimensional object
%
% hi - set to 1 for hipass instead of lowpass
%
% OUTPUTS:
%
% y - object interpolated along three dimensions
% filt - copy of the k space filter

sz = size(x);
[x_resh, n_slcs] = resh(x, 3);

for n = 1:n_slcs
	[x_resh(:,:,n), filt] = filt_slc(ord, cut, x_resh(:,:,n), hi);
end

y = reshape(x_resh, sz);

end

function [y_slc, filt] = filt_slc(ord, cut, x_slc, hi)
	sz = size(x_slc);
	mids = floor(sz/2)+1;
	[x, y] = meshgrid( (1:sz(2)) - mids(2), (1:sz(1)) - mids(1) );
	w = sqrt(x.^2 + y.^2);
	w = w ./ max(w(:));
	w = w / cut;
	filt = sqrt(1 ./ (1 + w.^(2*ord)));
	if hi == 1
		filt = 1 - filt;
	end
	x_ft = fftshift(fft2(x_slc));
	x_filt = x_ft .* filt;
	y_slc = ifft2(ifftshift(x_filt));
end	
	