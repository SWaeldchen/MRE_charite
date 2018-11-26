function [ diffOp ] = waveOp2_mu(u1, u2, gridSize, lambda )
%WAVEOP_MU Summary of this function goes here
%   Detailed explanation goes here


diffU1 = (u1(3:end) - u1(1:end-2))/4;
laplU1 = u1(1:end-2) - 2*u1(2:end-1) + u1(3:end);

diffU2 = (u2(3:end) - u2(1:end-2))/4;
laplU2 = u2(1:end-2) - 2*u2(2:end-1) + u2(3:end);

% diffMat

u1Diags = [[diffU1;zeros(2*gridSize-2,1)],[0;laplU1;zeros(2*gridSize-3,1)],[0;0;-diffU1;zeros(2*gridSize-4,1)]];
u2Diags = [[diffU2;zeros(2*gridSize-2,1)],[0;laplU2;zeros(2*gridSize-3,1)],[0;0;-diffU2;zeros(2*gridSize-4,1)]];
selfDiags = [[lambda*ones(gridSize,1); ones(2*gridSize-4,1)]];

% [u1Diags,u2Diags]

diffOp = spdiags([u1Diags,u2Diags, selfDiags], [0,1,2,-(gridSize-2),-(gridSize-3),-(gridSize-4), -(2*gridSize-4)], 3*gridSize -4, gridSize);

end

