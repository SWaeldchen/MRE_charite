function [D, Dx, Dy] = make_nabla(M, N)

%% image
np = M*N;
idx = reshape([1:np], M,N);

%% u_{i,j+1} - u_{i,j}
idx1 = idx;
idx2 = idx(:,[2:N,N]);

Dx = -sparse(1:np, idx1(:), ones(np,1), np, np) + ...
      sparse(1:np, idx2(:), ones(np,1), np, np);
   
%% u_{i+1,j} - u_{i,j}
idx1 = idx;
idx2 = idx([2:M,M],:);

Dy = -sparse(1:np, idx1(:), ones(np,1), np, np) + ...
      sparse(1:np, idx2(:), ones(np,1), np, np);
    
D = [Dx;Dy];