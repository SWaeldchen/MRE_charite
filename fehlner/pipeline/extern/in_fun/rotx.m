function [VEC, R]=rotx(vec1,vec2)
%
% rotate
%
vec1=vec1(:)'/norm(vec1);
vec2=vec2(:)/norm(vec2);

r=cross(vec1,vec2);

ang=acos(vec1*vec2);
c=cos(ang);
s=sin(ang);
t=1-cos(ang);

R=[c+t*r(1)^2, t*r(1)*r(2)-s*r(3), t*r(1)*r(3)+s*r(2);...
   t*r(1)*r(2)+s*r(3), c+t*r(2)^2, t*r(2)*r(3)-s*r(1);...
   t*r(1)*r(3)-s*r(2), t*r(2)*r(3)+s*r(1), c+t*r(3)^2];

VEC=R*vec1';
