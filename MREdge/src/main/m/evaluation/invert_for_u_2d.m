function [u] = invert_for_u_2d(mu, boundaryU, freqVec, sz)
%INVERT_FOR_U_2D Summary of this function goes here
%   Detailed explanation goes here

gridSize = max(sz);

numofFreq = length(freqVec);

u = []; % Wavefield for multiple frequencies

for freq = 1:numofFreq
   
    sigma = (2*pi*freqVec(freq))^2/gridSize^2;
    navOp = nav_stokes_op_2d(mu, sigma, sz);
    

    nav_solution = full(navOp\ndSparse(boundaryU, [2*prod(sz),1]));
    
    u = cat(4, u, reshape(nav_solution, [sz,2]));
    
end

% tic
% [iL, iU] = ilu(navOp);
% a = toc
% 
% tic
% [L, U] = lu(navOp);
% b = toc
% 
% sp_norm(iL - L), sp_norm(iU - U)
% 
% condest(navOp)
% 
% condest(iL\navOp/iU)

end

