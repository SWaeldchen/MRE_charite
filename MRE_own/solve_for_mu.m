function [ output_args ] = solve_for_mu( input_args )
%SOLVE_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

diffMat = zeros(2*(gridSize-2), gridSize);
diffVec = zeros(2*(gridSize-2), 1);

for i=2:gridSize-1

    diffMat(i-1, i-1:i+1) = [(u1(i+1)-u1(i-1))/4, u1(i+1)-2*u1(i)+u1(i-1), -(u1(i+1)-u1(i-1))/4];
    diffMat(i-1 + gridSize-2, i-1:i+1) = [(u2(i+1)-u2(i-1))/4, u2(i+1)-2*u2(i)+u2(i-1), -(u2(i+1)-u2(i-1))/4];
    
    diffVec(i-1) = -D1*u1(i);
    diffVec(i-1 + gridSize-2) = -D2*u2(i);

end

diffU1 = u1[:end-2] - u1[3:end];
laplU1 = 





mu = diffMat\diffVec;



end

