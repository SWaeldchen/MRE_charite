function [u] = invert_for_u(mu, D, leftBound, rightBound, gridSize)
%SOLVE_FOR_U Summary of this function goes here
%   Detailed explanation goes here

diffOp = waveOp_u(mu, D, gridSize);
boundVec = [leftBound; zeros(gridSize-2,1); rightBound];
u = diffOp\boundVec;

end