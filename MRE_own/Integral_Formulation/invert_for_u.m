function [ u ] = invert_for_u( mu, sigma, boundary)
%SOLVE_FOR_U Summary of this function goes here
%   Detailed explanation goes here


N = length(mu);

boundVec = [boundary(1); zeros(N-2,1); boundary(2)];

u = waveOp_for_u(mu, sigma)\boundVec;



end

