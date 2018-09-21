function [Res] = correct_boundary(M, shortDims, inDims)
%CORRECTION Summary of this function goes here
%   Detailed explanation goes here

shape = size(M);

Mind = cell(length(shape),1);
Rind = cell(length(shape),1);
zLen = zeros(1,length(shape));

for dim=1:length(shape)
    
    if ismember(dim, shortDims)
        Mind{dim} = 1:shape(dim);
        Rind{dim} = 2:shape(dim)+1;
        zLen(dim) = shape(dim)+2;
    elseif ismember(dim, inDims)
        Mind{dim} = 1:shape(dim);
        Rind{dim} = 1:shape(dim);
        zLen(dim) = shape(dim);
    else
        Mind{dim} = 2:shape(dim)-1;
        Rind{dim} = 2:shape(dim)-1;
        zLen(dim) = shape(dim);
    end
    
    
    
end

Res = sparse(prod(zLen),1);
Res = ndSparse(Res, zLen);

Res(Rind{:}) = M(Mind{:});


end

