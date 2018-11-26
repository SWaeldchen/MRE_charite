function [ Op ] = uOp_for_mu_circle( u )
%UOP_FOR_MU_CIRCLE Summary of this function goes here
%   Detailed explanation goes here

n = length(u);

vec1 = [ diff(u); 0];
vec2 = [ diff(u); u(1)-u(end)];
vec3 = [ zeros(n-1, 1); u(1)-u(end)];

Op = spdiags([-vec1, vec2, -vec3], [-1,0,n-1], n, n);


end

