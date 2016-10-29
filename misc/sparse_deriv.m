function [A] = sparse_deriv (sz, ord)
% makes a sparse first or second order derivative matrix
% to the needed dimesions using kronecker products
%
% b is a sample of the data to give the dimensions

  if numel(sz) == 2 && (sz(1) == 1 || sz(2) == 1) 
    ndims = 1;
  elseif numel(sz) == 2
    ndims = 2;
  elseif numel(sz) == 3
    ndims = 3;
  end

  if ord == 1
    A = nabla(sz, ndims);
  elseif ord == 2
    A = laplacian(sz, ndims);
  end
    
end

function A = nabla(sz, ndims)
    
    ones_y = ones(sz(1),1);
    dy = spdiags([-ones_y ones_y], [0 1], sz(1),sz(1));
    if ndims > 1
        ones_x = ones(sz(2),1);
        dx = spdiags([-ones_x ones_x], [0 1], sz(2),sz(2));
    end
    if ndims > 2
        ones_z = ones(sz(3),1);
        dz = spdiags([-ones_z ones_z], [0 1], sz(3),sz(3));
    end

    Iy = speye(sz(1));
    if ndims == 1
        A = dy;
    elseif ndims == 2
        Ix = speye(sz(2));
        A = kron(Ix,dy) + kron(dx,Iy);
    elseif ndims == 3
        Ix = speye(sz(2));
        Iz = speye(sz(3));
        A = kron(Iz, kron(Ix, dy)) + kron(Iz, kron(dx, Iy))...
            + kron(kron(dz,Ix),Iy);
    end

end

function A = laplacian(sz, ndims)

    ones_y = ones(sz(1),1);
    dy = spdiags([-ones_y 2*ones_y -ones_y], [-1 0 1], sz(1),sz(1));
    if ndims > 1
        ones_x = ones(sz(2),1);
        dx = spdiags([-ones_x 2*ones_x -ones_x], [-1 0 1], sz(2),sz(2));
    end
    if ndims > 2
        ones_z = ones(sz(3),1);
        dz = spdiags([-ones_z 2*ones_z -ones_z], [-1 0 1], sz(3),sz(3));
    end

    Iy = speye(sz(1));
    if ndims == 1
        A = dy;
    elseif ndims == 2
        Ix = speye(sz(2));
        A = kron(Ix,dy) + kron(dx,Iy);
    elseif ndims == 3
        Ix = speye(sz(2));
        Iz = speye(sz(3));
        A = kron(Iz, kron(Ix, dy)) + kron(Iz, kron(dx, Iy))...
            + kron(kron(dz,Ix),Iy);
    end

end
