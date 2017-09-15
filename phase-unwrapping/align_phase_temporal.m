function v = align_phase_temporal(u, mask)
sz = size(u);
v = zeros(sz);

for q = 1:sz(6)
    for p = 1:sz(5)
        for m = 1:sz(3)
            v(:,:,m,1,q) = u(:,:,m,1,p);
            for n = 2:sz(4)
                prev_slc = u(:,:,m,n-1,p);
                curr_slc = u(:,:,m,n,p,q);
                mask_prev = prev_slc(mask(:,:,m));
                mask_curr = curr_slc(mask(:,:,m));
                med_prev = median(mask_prev);
                med_curr = median(mask_curr);
                diff = med_prev - med_curr;
                diff_sign = sign(diff);
                diff_flr = floor(abs(diff) / (2*pi));
                %disp(['Median previous: ', num2str(med_prev), ' median current: ',num2str(med_curr),' difference: ', num2str(diff), 'adjustments: ', num2str(diff_flr)]);
                v(:,:,m,n,p,q) = curr_slc + 2*pi*diff_flr*diff_sign;
            end
        end
    end
end
v = reshape(v, sz);