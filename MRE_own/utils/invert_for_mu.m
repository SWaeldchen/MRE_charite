function [ mu ] = invert_for_mu(D1, D2, u1, u2, gridSize)
%INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

diffOp = waveOp_mu(u1, u2, gridSize);

diffVec = [-D1*u1(2:end-1); -D2*u2(2:end-1)];

mu = diffOp\diffVec;


end

