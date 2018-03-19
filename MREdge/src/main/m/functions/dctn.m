function y = dctn(x, dims)
% y = dctn(x)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% N-dimensional discrete cosine transform.
% Requires no toolboxes -- uses Matlab-compatible modification of GNU octave DCT method
%
% INPUTS:
%
% x - 1+ dimensional object
%
% OUTPUTS:
%
% y - n-dimensional dct of the object

if nargin < 2
    dims = ndims(x);
end
rem_dims = ndims(x) - dims;
for d = 1:dims
    sz = size(x);
	[x_resh, num_cols] = resh(x, 2);
	for n = 1:num_cols
		x_resh(:,n) = dct_eb(x_resh(:,n));
	end
	x = reshape(x_resh, sz);
	x = shiftdim(x, 1);
end
y = shiftdim(x, rem_dims);