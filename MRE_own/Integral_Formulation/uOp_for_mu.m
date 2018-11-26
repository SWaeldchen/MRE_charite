function [ Op ] = uOp_for_mu(u)
%UOP_FOR_MU Summary of this function goes here
%   Detailed explanation goes here


vec = diff(u);

n = length(u);

Op = spdiags([-vec(1:end-1), vec(2:end)], [0,1], n-2, n-1);



end

