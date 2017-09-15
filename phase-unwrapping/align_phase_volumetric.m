function v = align_phase_volumetric(u, mask)
sz = size(u);
[u_resh, n_vols] = resh(u,4);
v_resh = zeros(size(u_resh));

 for n = 1:n_vols
    v_resh(:,:,1,n) = u_resh(:,:,1,n);
    for m = 2:sz(3)
        prev_slc = u_resh(:,:,m,n);
        curr_slc = u_resh(:,:,m,n);
        mask_prev = prev_slc(mask(:,:,m));
        mask_curr = curr_slc(mask(:,:,m));
        med_prev = median(mask_prev);
        med_curr = median(mask_curr);
        diff = med_prev - med_curr;
        diff_sign = sign(diff);
        diff_flr = floor(abs(diff) / (pi));
        %disp(['Median previous: ', num2str(med_prev), ' median current: ',num2str(med_curr),' difference: ', num2str(diff), 'adjustments: ', num2str(diff_flr)]);
        v_resh(:,:,m,n) = curr_slc + pi*diff_flr*diff_sign;
    end
 end

v = reshape(v_resh, sz);