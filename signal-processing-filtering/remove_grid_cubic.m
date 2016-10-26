function [U_filt] = remove_grid_cubic(U, super_factor)
	U = squeeze(U);
	U(isnan(U)) = 0;
    if ndims(U) == 2
        U_filt = remove_grid_cubic_2d(U, super_factor);
    elseif ndims(U) == 3
        U_filt = remove_grid_cubic_3d(U, super_factor);
    elseif ndims(U) == 4
		U_filt = remove_grid_cubic_4d(U, super_factor);
	else
        display('only 2d, 3d or 4d data allowed');
		U_filt = [];
    end

end

function [U_filt] = remove_grid_cubic_2d(U, super_factor)
    szu = size(U);
    U_filt = zeros(szu);
    y_indices = super_factor+1 : super_factor : szu(1)-super_factor;
    y1_indices = y_indices - 1;
    y0_indices = y_indices - 2;
    y2_indices = y_indices + 1;
    y3_indices = y_indices + 2;
    surrounding_indices = unique(sort(cat(2, y0_indices, y1_indices, y2_indices, y3_indices)));
    for n = 1:szu(2)
        U_filt(:,n) = spline(surrounding_indices, U(surrounding_indices,n), 1:szu(1));
    end

    x_indices = super_factor+1 : super_factor : szu(2)-super_factor;
    x1_indices = x_indices - 1;
    x0_indices = x_indices - 2;
    x2_indices = x_indices + 1;
    x3_indices = x_indices + 2;
    surrounding_indices = unique(sort(cat(2, x0_indices, x1_indices, x2_indices, x3_indices)));
    for n = 1:szu(1)
        U_filt(n,:) = spline(surrounding_indices, U_filt(n,surrounding_indices), 1:szu(2));
    end

end

function [U_filt] = remove_grid_cubic_3d(U, super_factor)
    szu = size(U);
    U_filt = zeros(szu);
    y_indices = super_factor+1 : super_factor : szu(1)-super_factor;
    y1_indices = y_indices - 1;
    y0_indices = y_indices - 2;
    y2_indices = y_indices + 1;
    y3_indices = y_indices + 2;
    surrounding_indices = unique(sort(cat(2, y0_indices, y1_indices, y2_indices, y3_indices)));
    for k = 1:szu(3)
        for j = 1:szu(2)
            U_filt(:,j,k) = spline(surrounding_indices, U(surrounding_indices,j,k), 1:szu(1));
        end
    end

    x_indices = super_factor+1 : super_factor : szu(2)-super_factor;
    x1_indices = x_indices - 1;
    x0_indices = x_indices - 2;
    x2_indices = x_indices + 1;
    x3_indices = x_indices + 2;
    surrounding_indices = unique(sort(cat(2, x0_indices, x1_indices, x2_indices, x3_indices)));
    for i = 1:szu(1)
        for k = 1:szu(3)
            U_filt(i,:,k) = spline(surrounding_indices, U_filt(i,surrounding_indices,k), 1:szu(2));
        end
    end

    z_indices = super_factor+1 : super_factor : szu(3)-super_factor;
    z1_indices = z_indices - 1;
    z0_indices = z_indices - 2;
    z2_indices = z_indices + 1;
    z3_indices = z_indices + 2;
    surrounding_indices = unique(sort(cat(2, z0_indices, z1_indices, z2_indices, z3_indices)));
    for i = 1:szu(1)
        for j = 1:szu(2)
            U_filt(i,j,:) = spline(surrounding_indices, U_filt(i,j,surrounding_indices), 1:szu(3));
        end
    end

end

function [U_filt] = remove_grid_cubic_4d(U, super_factor)
    U_filt = zeros(size(U));
    szu = size(U);
    for n = 1:szu(4)
       U_filt(:,:,:,n) = remove_grid_cubic_3d(U(:,:,:,n), super_factor);
    end
end
