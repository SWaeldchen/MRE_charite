function [ u] = solve_for_u(mu, D, leftBound, rightBound, gridSize)
%SOLVE_FOR_U Summary of this function goes here
%   Detailed explanation goes here

uBuild = zeros(gridSize, 2);

uBuild(1:2, 1) = [1,1.1];
uBuild(1:2, 2) = [1,0.9];

for i = 2:gridSize-1

    c = (2*mu(i) - D)/( (mu(i+1)-mu(i-1))/4 + mu(i));
    
    uBuild(i+1, 1:2) = c*uBuild(i, 1:2) - uBuild(i-1, 1:2);

end

boundMatrix = [uBuild(1,1:2); uBuild(end,1:2)];

coeff = boundMatrix\[leftBound; rightBound];


u = uBuild*coeff;


end

