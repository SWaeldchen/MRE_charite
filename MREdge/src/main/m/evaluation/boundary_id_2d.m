function [boundaryId] = boundary_id_2d(lx)
%BOUNDARY_ID Summary of this function goes here
%   Detailed explanation goes here

boundary = zeros(lx);

x1Vec = zeros(lx(1),1); x1Vec(1) =1; x1Vec(end) = 1;
x2Vec = zeros(1,lx(2)); x2Vec(1) =1; x2Vec(end) = 1;

boundary(x1Vec|x2Vec) = 1;

boundaryId = spdiags(boundary(:), 0, prod(lx), prod(lx));



end

