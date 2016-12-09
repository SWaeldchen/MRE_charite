function [A] = sparse_deriv (sz, ord)
% makes a sparse first or second order derivative matrix
% to the needed dimesions using kronecker products
%
% b is a sample of the data to give the dimensions

  if numel(sz) == 2 && (sz(1) == 1 || sz(2) == 1) 
    n_dims = 1;
  elseif numel(sz) == 2
    n_dims = 2;
  elseif numel(sz) == 3
    n_dims = 3;
  end

  if ord == 1
    A = nabla(sz, n_dims);
  elseif ord == 2
    A = laplacian(sz, n_dims);
  end
    
end

function A = nabla(sz, n_dims)
    
    ones_y = ones(sz(1),1);
    dy = spdiags([-ones_y ones_y], [0 1], sz(1),sz(1));
    if n_dims > 1
        ones_x = ones(sz(2),1);
        dx = spdiags([-ones_x ones_x], [0 1], sz(2),sz(2));
    end
    if n_dims > 2
        ones_z = ones(sz(3),1);
        dz = spdiags([-ones_z ones_z], [0 1], sz(3),sz(3));
    end

    Iy = speye(sz(1));
    if n_dims == 1
        A = dy;
    elseif n_dims == 2
        Ix = speye(sz(2));
        A = kron(Ix,dy) + kron(dx,Iy);
    elseif n_dims == 3
        Ix = speye(sz(2));
        Iz = speye(sz(3));
        A = kron(Iz, kron(Ix, dy)) + kron(Iz, kron(dx, Iy))...
            + kron(kron(dz,Ix),Iy);
    end

end

function A = laplacian(sz, n_dims)

    ones_y = ones(sz(1),1);
    dy = spdiags([-ones_y 2*ones_y -ones_y], [-1 0 1], sz(1),sz(1));
    if n_dims > 1
        ones_x = ones(sz(2),1);
        dx = spdiags([-ones_x 2*ones_x -ones_x], [-1 0 1], sz(2),sz(2));
    end
    if n_dims > 2
        ones_z = ones(sz(3),1);
        dz = spdiags([-ones_z 2*ones_z -ones_z], [-1 0 1], sz(3),sz(3));
    end

    Iy = speye(sz(1));
    if n_dims == 1
        A = dy;
    elseif n_dims == 2
        Ix = speye(sz(2));
        A = kron(Ix,dy) + kron(dx,Iy);
    elseif n_dims == 3
        Ix = speye(sz(2));
        Iz = speye(sz(3));
        A = kron(Iz, kron(Ix, dy)) + kron(Iz, kron(dx, Iy))...
            + kron(kron(dz,Ix),Iy);
    end

end
