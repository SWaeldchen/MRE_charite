function [N] = nabla(sz)
%NABLA Summary of this function goes here
%   Detailed explanation goes here

numofDims = length(sz);

id = ndSparse(speye(prod(sz)), [sz, sz]);


N = cell(numofDims, 1);

for dim = 1:numofDims
    
    kernel = diff_kernel(dim, 1:numofDims, numofDims+1:2*numofDims);
    
    D_dim = convn(id, kernel, 'valid');
    
    N{dim} = sparse(reshape(D_dim, [prod(sz-2), prod(sz)]));
end



end

