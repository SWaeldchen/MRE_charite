function [outputArg1,outputArg2] = apply_diff(A, diffKernel, diffDims, spareDims)
%APPLY_DIFF Summary of this function goes here
%   Detailed explanation goes here

dims = length(size(A));

extDiffKernel = zeros(ones(1, dims)*3);

ind = cell(1,dims);

for i = 1:dims
    if ismember(i, diffDims)
        ind{i} = 1:3;
    else
        ind{i} = 2;
    end
end

extDiffKernel(ind{:}) = diffKernel;


        
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

