function [boundaryId] = boundary_id_3d(lx)
%BOUNDARY_ID Summary of this function goes here
%   Detailed explanation goes here

boundary = zeros(lx);

x1Vec = zeros(lx(1),1,1); x1Vec(1) =1; x1Vec(end) = 1;
x2Vec = zeros(1,lx(2),1); x2Vec(1) =1; x2Vec(end) = 1;
x3Vec = zeros(1,1,lx(3)); x3Vec(1) =1; x3Vec(end) = 1;

boundary(x1Vec|x2Vec|x3Vec) = 1;

boundaryId = spdiags(boundary(:), 0, prod(lx), prod(lx));



end

