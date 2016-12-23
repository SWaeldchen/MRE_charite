function y = idctn(x)
% y = idctn(x)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% N-dimensional inverse discrete cosine transform.
% Requires no toolboxes -- uses Matlab-compatible modification of GNU octave DCT method
%
% INPUTS:
%
% x - 1+ dimensional object
%
% OUTPUTS:
%
% y - n-dimensional dct of the object

sz = size(x);
for d = 1:ndims(x)
	[x_resh, num_cols] = resh(x, 2);
	for n = 1:num_cols
		x_resh(:,n) = idct_octave(x_resh(:,n));
	end
	x = reshape(x_resh, sz);
	x = shiftdim(x, 1);
end
