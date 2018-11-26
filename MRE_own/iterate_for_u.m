function [ uIter ] = iterate_for_u(mu, D, uStart, uClear, gridSize )
%ITERSTE_FOR_U Summary of this function goes here
%   Detailed explanation goes here



numofIter = 100000;

diffOp = waveOp_u(mu, D, gridSize);

uIter = uStart;
boundVec = [uStart(1); zeros(gridSize-2,1); uStart(end)];

lambda = 0.01;
alpha = 0.01;

for step=1:numofIter
    sum(abs((diffOp'*diffOp)*uIter - diffOp'*boundVec))
    uGrad = ((diffOp'*diffOp)*uIter - diffOp'*boundVec) + lambda*(uIter - uClear);
    
    uIter = uIter - alpha*uGrad;
    
    
end


end

