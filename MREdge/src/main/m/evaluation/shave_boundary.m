function [M] = shave_boundary(M, shave_dims)

for


shape = size(M);
shapeArg = mat2cell(shape', ones(length(shape), 1))
shapeArg{dim} = [1, shape(dim)-2, 1];

C = mat2cell(M, shapeArg{:});

M = C{2};
end