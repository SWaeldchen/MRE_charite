function [ u ] = invert_with_u_and_mu(mu, u_star, D, gridSize)
%INVERT_WITH_U_AND_MU Summary of this function goes here
%   Detailed explanation goes here

%SOLVE_FOR_U Summary of this function goes here
%   Detailed explanation goes here

diffOp = waveOp_part_mu(mu, D, gridSize);
boundVec = -D*u_star;
u = diffOp\boundVec;


end

