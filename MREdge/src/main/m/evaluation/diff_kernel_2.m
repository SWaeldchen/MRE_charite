function [kernel] = diff_kernel_2(diffDims, otherDims)

% Gives back a differential kernel over certain dimensions

diffKernel = [-1, 0, 1]/2;
lapKernel = [1, -2, 1];
diff_ijKernel = [[1, -1, 0]; [-1, 1, 0]; [0,0,0]];

if ~isempty(intersect(diffDims, otherDims))
    error("Same dimensions for diff and non-diff");
end

if length(diffDims) == 1
    kernel = diffKernel;
elseif length(diffDims) == 2
    if diffDims(1) == diffDims(2)
        kernel = lapKernel;
    else
        kernel = diff_ijKernel;
    end
else
    error("Don't do more than two derivatives")
end

numofDims = length(diffDims) + length(otherDims);

kernelShape = ones(1, numofDims);
kernelShape(diffDims) = 3;
    
kernel = reshape(kernel, kernelShape);

%%% Padding, used for reducing the boundary in the other
%%% dimensions ofter convolving

padShape = zeros(1, numofDims);
padShape(otherDims) = 1;

kernel = padarray(kernel, padShape);

end