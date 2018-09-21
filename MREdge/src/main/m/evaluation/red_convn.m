function [Res] = red_convn(A, kernel, dims)
%RED_CONVN Summary of this function goes here
%   Detailed explanation goes here

numofDims = length(size(A));

AShape = size(A);
kernelShape = size(kernel);

% Bring the kernel in the right shape to convolve around the right
% dimensions
ext_kernelShape = ones(1,length(AShape));
ext_kernelShape(dims) = max(kernelShape);

% Perform the convolution
Res = convn(A, reshape(kernel, ext_kernelShape), 'valid');

%% Zero-Padding around convolved dimension

% Extending the matrix
ind = num2cell(AShape);
Res(ind{:}) = 0;

% Shifting to the center
shiftVec = zeros(1, numofDims);
shiftVec(dims) = 1;
Res = circshift(Res, shiftVec);

end

