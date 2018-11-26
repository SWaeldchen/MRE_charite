function [ uFinal ] = two_stage_denoise(u, gridSize)
%TWO_STAGE_DENOISE Summary of this function goes here
%   Detailed explanation goes here

uDenoised = wlet_denoise(u, ceil(log2(gridSize)), 'db10', 0, 0, 5);

diffU = (uDenoised(2:end) - uDenoised(1:end-1));
tiffU = wlet_denoise(diffU, ceil(log2(gridSize)), 'db10', 0, 0, 5);
% 
% diffU = (tiffU(2:end) + tiffU(1:end-1))/2;
% 
% diags = [[-ones(gridSize-2,1)/2;0;0],[1;zeros(gridSize-2,1);1], [0;0;ones(gridSize-2,1)/2]];
% diffOp = spdiags(diags, [-1,0,1], gridSize, gridSize);
% 
% diffVec = [uDenoised(1);diffU;uDenoised(end)];
% 
% % uDenoised
% % a = diffOp*uDenoised
% % diffVec
% % diffU
% % (u(3:end) - u(1:end-2))/2
% 
% 
% uFinal = diffOp\diffVec;

diags = [[-ones(gridSize-1,1);1;0],[ones(gridSize,1);0]];
diffOp = spdiags(diags, [-1,0], gridSize+1, gridSize);

diffVec = [uDenoised(1);tiffU;uDenoised(end)];

%full(diffOp)

% uDenoised
%  a = diffOp*uDenoised
%  diffVec
% diffU
% (u(3:end) - u(1:end-2))/2


uFinal = diffOp\diffVec;

sum(uFinal-uDenoised)

%ud = (uFinal(3:end) - uFinal(1:end-2))/2

% plot(1:gridSize-1, diff(uDenoised), 1:gridSize-1, diff(uFinal));

end

