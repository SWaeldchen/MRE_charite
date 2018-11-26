function [ Op ] = uOp_for_mu_border( u )
%UOP_FOR_MU_BORDER Summary of this function goes here
%   Detailed explanation goes here


n = length(u);

vec1 = [ diff(u); 0];
vec2 = [ diff(u); 1];
vec3 = [ zeros(n-1, 1); 1];

Op = spdiags([-vec1, vec2, -vec3], [-1,0,n-1], n, n);


end

