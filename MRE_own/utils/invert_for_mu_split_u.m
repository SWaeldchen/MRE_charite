function [ mu ] = invert_for_mu_split_u(D1, D2, u1Self, u2Self, u1Noise, u2Noise, gridSize)
%INVERT_FOR_MU_SPLIT_U Summary of this function goes here
%   Detailed explanation goes here


diffOp = waveOp_mu(u1Self, u2Self, gridSize);

diffVec = [-D1*u1Noise(2:end-1); -D2*u2Noise(2:end-1)];

mu = diffOp\diffVec;


end

