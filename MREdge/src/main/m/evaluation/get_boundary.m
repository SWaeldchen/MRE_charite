function [boundaryU] = get_boundary(sz)
%GET_BOUNDARY Summary of this function goes here
%   Detailed explanation goes here

boundaryU1 = ndSparse(zeros(sz));
boundaryU2 = ndSparse(zeros(sz));
x1Vec = zeros(sz(1),1); x1Vec(1) =1; x1Vec(end) = 1;
x2Vec = zeros(1,sz(2)); x2Vec(1) =1; x2Vec(end) = 1;

sinBound = sin(2*pi*(0:sz(1)-1)/(sz(1)-1)) - sin(2*pi*(0:(sz(2)-1))'/(sz(2)-1));

boundaryU1(x1Vec|x2Vec) = sinBound(x1Vec|x2Vec);
boundaryU2(x1Vec|x2Vec) = -sinBound(x1Vec|x2Vec);

boundaryU = cat(3, boundaryU1, boundaryU2);

end

