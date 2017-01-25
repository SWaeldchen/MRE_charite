function y = pwrspec_2d(x, log, norm)
% y = pwrspec_2d(x, log, norm)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% Returns slicewise 2D power spectra for an Nd image volume
%
% INPUTS:
%
%
% x - 2 or higher dimensional object
%
% log - if nonzero, returns log power spectrum
%
% norm - if nonzero, returns normalized log power spectrum in dB
%
% OUTPUTS:
%
% y - object interpolated along three dimensions


if nargin < 3
	norm = 0;
	if nargin < 2
		log = 0;
	end
end
if ndims(x) < 2
	disp('MCNIT error: pwrspec_2d must have 2+d data');
end

sz = size(x);
[x_resh, n_slcs] = resh(x, 3);

for n = 1:n_slcs
	x_resh(:,:,n) = get_pwrspec(x_resh(:,:,n), log, norm);
end

y = reshape(x_resh, sz);

end

function y = get_pwrspec(x, log, norm)
	y = abs(fftshift(fft2(x)));
	if log ~= 0
		y = log(y);
		if norm ~= 0
			y = 10*log(normalize_image(y)) ./ log(10);
		end
	end
end	
	
