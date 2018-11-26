function [ muIter ] = iterate_mu(u1, u2, D1, D2, gridSize)
%ITERATE_MU Summary of this function goes here
%   Detailed explanation goes here

lambda = 0.0005

diffOp = waveOp2_mu(u1, u2, gridSize, lambda);
diffVec = [-D1*u1(2:end-1); -D2*u2(2:end-1)];

numofIterSteps = 500;

muLow = 0.5;
muHigh = 5;

muIter = (muHigh-muLow)/2*ones(gridSize, 1);
alpha = 20;
beta = 0.0005;

%muIter = muStart;


% 
% op = diffOp + lambda*

%muTV = zeros(size(muIter));
% 
%diffOp = diffOp + lambda*speye(size(diffOp));

for step = 1:numofIterSteps
    step
    diffVecNow = [diffVec;lambda*muIter];
    %diffVecNow(1:gridSize) = diffVecNow(1:gridSize) + lambda*muIter;
    
    muIter = diffOp\diffVecNow;
    
%     norm((diffOp'*diffOp)*muIter - diffOp'*diffVec)
%     %muIter = muIter - alpha*(muIter - muStart);
%     muIter = muIter - alpha*((diffOp'*diffOp)*muIter - diffOp'*diffVec);
%     [C,L] = wavedec(muIter, ceil(log2(gridSize)), 'db1');
%     muIter = muIter - beta*waverec(sign(C), L, 'db1');
%     %muIter = muIter - alpha*((diffOp'*diffOp)*muIter - diffOp'*diffVec);
    muIter(muIter<muLow) = muLow;
    muIter(muIter>muHigh) = muHigh;
    muIter = wlet_denoise(muIter, ceil(log2(gridSize)), 'db1', 0, 0, 9);
%     
%     muSign = sign(muIter(1:end-1) - muIter(2:end));
%     muTV = zeros(size(muIter));
%     muTV(2:end) = muTV(2:end) - muSign;
%     muTV(1:end-1) = muTV(1:end-1) + muSign;
%     muIter = muIter - beta*muTV;
end

%muIter = wlet_denoise(muIter, ceil(log2(gridSize)), 'db1', 0.98, 0, 5);
    

end

