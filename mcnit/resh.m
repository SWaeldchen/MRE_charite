function [y, final_dim_size] = resh(x, d)
% y = reshape(x,d)
% Part of the MCNIT: M-code Complex and Nd Imaging Toolbox
% (c) Eric Barnhill 2016 All Rights Reserved.
%
% DESCRIPTION:
%
% Alternate reshape method, reshapes the object to a fixed set of dimensions.
% Dimensions less than d are preserved identically and the remaining dimensions
% are vectorized along dimension d.
%
% INPUTS:
%
% x - object
% d - desired dimensions
%
% OUTPUTS:
%
% y - reshaped object

if ndims(x) < d
	%disp('MCNIT warning: resh: dims of x less than dims of d. no reshape.');
	y = x;
	final_dim_size = 1;
else 
	sz = size(x);
	final_dim_size = prod(sz(d:end));
	y = reshape(x, [sz(1:d-1) final_dim_size]);
end

end
