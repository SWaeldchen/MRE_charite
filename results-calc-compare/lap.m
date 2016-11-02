function y = lap(x,dims)

if nargin == 1
    dims = ndims(x);
end

if dims == 3
	laplacian = get3dLaplacian();
	y = convn(x, laplacian, 'same');
elseif dims == 2 && size(x,1) > 1 && size(x,2) > 1
	y = convn(x, [0 1 0; 1 -4 1; 0 1 0], 'same');
else
	y = conv(x, [1 -2 1], 'same');
end