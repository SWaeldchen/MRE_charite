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
  sr_cub = sr_fac.^3;
  i = zeros(sr_length,1);
  j = zeros(sr_length,1);
  s = ones(sr_length,1);
  
  for z = 1:sz(3)  % step through rows of A
    for x = 1:sz(2)
      for y = 1:sz(1)
        or_index = get_3d_index(y, x, z, sz);
        subs = get_subs(y, x, z, super_sz, sr_fac);
        range = (or_index-1)*sr_cub+1:or_index*sr_cub;
        i(range) = ones(sr_cub,1)*or_index;
        j(range) = subs;        
      end
    end
  end
  
  A = sparse(i,j,s);
 
end

function i = get_3d_index(y, x, z, sz)
    i = y + (x-1)*sz(1) + (z-1)*sz(1)*sz(2);
end
    

function subs = get_subs(y, x, z, super_sz, sr_fac)
    y_start = (y-1)*sr_fac;
    x_start = (x-1)*sr_fac;
    z_start = (z-1)*sr_fac;
    subs = zeros(sr_fac^3,1);
    for z = z_start+1:z_start+sr_fac
        for x = x_start+1:x_start+sr_fac
            for y = y_start+1:y_start+sr_fac
                sub_ind = get_3d_index(y-y_start, x-x_start, z-z_start, [sr_fac sr_fac sr_fac]);
                sr_index = get_3d_index(y, x, z, super_sz);
                subs(sub_ind) = sr_index;
            end
        end
    end
end
