function [M] = shave_boundary_exept(M, spare_dims)

sh = size(M);
indRemain = cell(length(sh), 1);

for dim = 1: length(sh)
   
    if ismember(dim, spare_dims)
        indRemain{dim} = 1:sh(dim);
        
    else
        indRemain{dim} = 2:sh(dim)-1;
    end
end

M = M(indRemain{:});
    
    
end


% shape = size(M);
% dims = length(shape);
% 
% shapeArg = num2cell([ones(dims,1), shape'-2, ones(dims,1)], 2);
% shapeArg{dim} = shape(dim);
% 
% C = mat2cell(M, shapeArg{:});
% 
% select = num2cell(2*ones(dims,1), 2);
% select{dim} = 1;
% 
% M = C{select{:}};

