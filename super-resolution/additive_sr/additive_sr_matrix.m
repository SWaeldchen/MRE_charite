function A = additive_sr_matrix(sz, sr_fac)
  
  % creates A matrix for Ax = b additive SR problem.
  % sz is the dimensions of the original resolution data
  % sr_fac is the super resolution factor (integer)
  
  if numel(sz) == 2 && (sz(1) == 1 || sz(2) == 1) 
    A = sr_matrix_1d_data(sz, sr_fac);
  elseif numel(sz) == 2
    A = sr_matrix_2d_data(sz, sr_fac);
  elseif numel(sz) == 3
    A = sr_matrix_3d_data(sz, sr_fac);
  end
  
end

function A = sr_matrix_1d_data(sz, sr_fac)
  
  or_length = prod(sz);
  super_sz = [sz(1) * sr_fac, 1];
  sr_length = prod(super_sz);
  
  ones_kernel = ones(1, sr_fac);
  A = sparse(or_length, sr_length);
  
  for y = 1:sz(1)
    row_y = zeros(1, super_sz(1));
    index_y = (y-1)*sr_fac + 1;        
    row_y(index_y:1:(index_y+sr_fac-1)) = ones_kernel;
    A(y, :) = row_y;
  end
 
end

function A = sr_matrix_2d_data(sz, sr_fac)
  
  or_length = prod(sz);
  super_sz = sz * sr_fac;
  sr_length = prod(super_sz);
  
  ones_kernel = ones(1, sr_fac);
  A = sparse(or_length, sr_length);
  
  for x = 1:sz(2)
    for y = 1:sz(1)
      row_x = zeros(1, super_sz(2));
      row_y = zeros(1, super_sz(1));
      index_x = (x-1)*sr_fac + 1;
      index_y = (y-1)*sr_fac + 1;        
      row_x(index_x:1:(index_x+sr_fac-1)) = ones_kernel;
      row_y(index_y:1:(index_y+sr_fac-1)) = ones_kernel;
      row_index = (y-1) + (x-1)*sz(1) + 1;
      A(row_index, :) = kron(row_y, row_x);
    end
  end
 
end

function A = sr_matrix_3d_data(sz, sr_fac)
  
  or_length = prod(sz);
  super_sz = sz * sr_fac;
  sr_length = prod(super_sz);
  
  ones_kernel = ones(1, sr_fac);
  A = sparse(or_length, sr_length);
  
  for z = 1:sz(3)  % step through rows of A
    for x = 1:sz(2)
      for y = 1:sz(1)
        row_x = zeros(1, super_sz(2));
        row_y = zeros(1, super_sz(1));
        row_z = zeros(1, super_sz(3));
        index_x = (x-1)*sr_fac + 1;
        index_y = (y-1)*sr_fac + 1;        
        index_z = (z-1)*sr_fac + 1;
        row_x(index_x:1:(index_x+sr_fac-1)) = ones_kernel;
        row_y(index_y:1:(index_y+sr_fac-1)) = ones_kernel;
        row_z(index_z:1:(index_z+sr_fac-1)) = ones_kernel;
        row_index = (y-1) + (x-1)*sz(1) +  (z-1)*sz(1)*sz(2) + 1;
        A(row_index, :) = kron(row_y, row_x, row_z);
      end
    end
  end
 
end
