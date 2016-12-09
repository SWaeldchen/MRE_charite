function [D, Dx, Dy, Dz] = make_nabla_3d(I, J, K)

%% image
np = I*J*K;
idx = reshape([1:np], [I,J,K]);

%% u_{i,j+1, k} - u_{i,j, k}
idx1 = idx;
idx2 = idx(:,[2:J,J],:);

Dx = -sparse(1:np, idx1(:), ones(np,1), np, np) + ...
      sparse(1:np, idx2(:), ones(np,1), np, np);
   
%% u_{i+1,j, k} - u_{i,j,k}
idx1 = idx;
idx2 = idx([2:I,I],:,:);

Dy = -sparse(1:np, idx1(:), ones(np,1), np, np) + ...
      sparse(1:np, idx2(:), ones(np,1), np, np);
  
%% u_{i,j,k+1} - u_{i,j,k}
idx1 = idx;
idx2 = idx(:,:,[2:K,K]);

Dz = -sparse(1:np, idx1(:), ones(np,1), np, np) + ...
      sparse(1:np, idx2(:), ones(np,1), np, np);  
    
D = [Dx;Dy;Dz];