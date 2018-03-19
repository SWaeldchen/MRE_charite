function [ nabla ] = grad3( image, spacing, valid )
% takes nabla operator of 3d image
if (nargin == 1) 
    spacing = 1;
end

[x, y, z] = gradient(image, spacing);
nabla = x + y + z;
if nargin < 3
    valid = 0;
end
if (valid > 0) 
    nabla = trimEdges3(nabla,1);
end
    
    
end

