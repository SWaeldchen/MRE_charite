function del_J2 = grad_J(y, epsilon)
    grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
    div = @(v)v([2:end 1],:,1)-v(:,:,1) + v(:,[2:end 1],2)-v(:,:,2);
    lsq = @(v)sqrt( (v([2:end 1],:,1)-v(:,:,1)).^2 + (v(:,[2:end 1],2)-v(:,:,2)).^2 );
    grad_both = grad(y);
    gradx = grad_both(:,:,1);
    grady = grad_both(:,:,2);
    norm_vals = smoothed_L1(gradx, grady, epsilon);
    gradx_norm = gradx ./ norm_vals;
    grady_norm = grady ./ norm_vals;
    norm_both = cat(3, gradx_norm, grady_norm);
    del_J2 = -div(norm_both);
    del_J2 = sqrt(gradx + grady).^2;
end
