function [boundaryU] = get_boundary_3d(sz)
%GET_BOUNDARY Summary of this function goes here
%   Detailed explanation goes here

boundaryU1 = ndSparse(zeros(sz));
boundaryU2 = ndSparse(zeros(sz));
boundaryU3 = ndSparse(zeros(sz));

x1Vec = zeros(sz(1),1,1); x1Vec(1) =1; x1Vec(end) = 1;
x2Vec = zeros(1,sz(2),1); x2Vec(1) =1; x2Vec(end) = 1;
x3Vec = zeros(1,1,sz(3)); x3Vec(1) =1; x3Vec(end) = 1;

sinBound =    sin(pi*reshape((0:sz(1)-1)/(sz(1)-1), [sz(1),1,1])) ...
            - sin(pi*reshape((0:sz(2)-1)/(sz(2)-1), [1,sz(2),1])) ...
            + sin(pi*reshape((0:sz(3)-1)/(sz(3)-1), [1,1,sz(3)]));

sinBound = sinBound + rand(size(sinBound));
        
boundaryU1(x1Vec|x2Vec|x3Vec) = sinBound(x1Vec|x2Vec|x3Vec);
boundaryU2(x1Vec|x2Vec|x3Vec) = -sinBound(x1Vec|x2Vec|x3Vec);
boundaryU3(x1Vec|x2Vec|x3Vec) = sinBound(x1Vec|x2Vec|x3Vec);

boundaryU = cat(4, boundaryU1, boundaryU2, boundaryU3);

end

