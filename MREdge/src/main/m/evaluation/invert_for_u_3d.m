function [u] = invert_for_u_3d(mu, boundaryU, freqVec, sz)

gridSize = max(sz);

numofFreq = length(freqVec);

u = []; % Wavefield for multiple frequencies

for freq = 1:numofFreq
   
    sigma = (2*pi*freqVec(freq))^2/gridSize^2;
    navOp = nav_stokes_op_3d(mu, sigma, sz); 
    nav_solution = full(navOp\ndSparse(boundaryU, [3*prod(sz),1]));
    

    u = cat(5, u, reshape(nav_solution, [sz,3]));
    
    
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

