function [U_cent] = recenter_slices(U);

sz = size(U);
quarter = round(sz(U)/4);
center_area = U(quarter:end-quarter, quarter:end-quarter, :, :, :);
medians = median(median(center_area));
for m = 1:sz(3)
    for n = 1:sz(4)
        for p = 1:sz(5)
            U_cent(:,:,m,n,p) = U(:,:,m,n,p) = medians(m,n,p);
        end
    end
end
