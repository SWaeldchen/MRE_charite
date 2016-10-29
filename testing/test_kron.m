function A = make_sr_matrix(b, sr_fac)
  
  % creates A matrix for Ax = b additive SR problem.
  
  sz = size(b);
  if numel(sz) == 1
    A = sr_matrix_1d_data(b, sr_fac);
  elseif numel(sz) == 2
    A = sr_matrix_2d_data(b, sr_fac);
  elseif numel(sz) == 3
    A = sr_matrix_3d_data(b, sr_fac);
  end
  
  
end

function A = sr_matrix_1d_data(b, sr_fac); 
  
  sz = size(b)
  or_length = prod(sz);
  super_sz = sz * super_fac;
  sr_length = prod(super_sz);
  
  b_size = [or_length, 1];
  x_size = [sr_length, 1];
  ones_kernel = ones(1, super_fac);
  A = sparse(or_length, sr_length);
  
    for y = 1:sz(1)
      row_y = zeros(1, super_sz(1));
      index_y = (y-1)*super_fac + 1;        
      row_y(index_y:1:(index_y+super_fac-1)) = ones_kernel;
      row_index = (y-1) + (x-1)*sz(1);
      A(row_index, :) = row_y;
    end
  end
 
end

function A = sr_matrix_2d_data(b, sr_fac); 
  
  sz = size(b)
  or_length = prod(sz);
  super_sz = sz * super_fac;
  sr_length = prod(super_sz);
  
  b_size = [or_length, 1];
  x_size = [sr_length, 1];
  ones_kernel = ones(1, super_fac);
  A = sparse(or_length, sr_length);
  
  for x = 1:sz(2)
    for y = 1:sz(1)
      row_x = zeros(1, super_sz(2));
      row_y = zeros(1, super_sz(1));
      index_x = (x-1)*super_fac + 1;
      index_y = (y-1)*super_fac + 1;        
      row_x(index_x:1:(index_x+super_fac-1)) = ones_kernel;
      row_y(index_y:1:(index_y+super_fac-1)) = ones_kernel;
      row_index = (y-1) + (x-1)*sz(1);
      A(row_index, :) = kron(row_y, row_x);
    end
  end
 
end

function A = sr_matrix_3d_data(b, sr_fac); 
  
  sz = size(b)
  or_length = prod(sz);
  super_sz = sz * super_fac;
  sr_length = prod(super_sz);
  
  b_size = [or_length, 1];
  x_size = [sr_length, 1];
  ones_kernel = ones(1, super_fac);
  A = sparse(or_length, sr_length);
  
  for z = 1:sz(3)  % step through rows of A
    for x = 1:sz(2)
      for y = 1:sz(1)
        row_x = zeros(1, super_sz(2));
        row_y = zeros(1, super_sz(1));
        row_z = zeros(1, super_sz(3));
        index_x = (x-1)*super_fac + 1;
        index_y = (y-1)*super_fac + 1;        
        index_z = (z-1)*super_fac + 1;
        row_x(index_x:1:(index_x+super_fac-1)) = ones_kernel;
        row_y(index_y:1:(index_y+super_fac-1)) = ones_kernel;
        row_z(index_z:1:(index_z+super_fac-1)) = ones_kernel;
        row_index = (y-1) + (x-1)*sz(1) +  (z-1)*sz(1)*sz(2) + 1;
        A(row_index, :) = kron(row_y, row_x, row_z);
      end
    end
  end
 
end
