function ims = compare_mags(x)

sz = size(x);
n_subj = sz(1);
n_levels = sz(2);
middle_slice = round(size(x{1,1},3)/2);
ims = [];
for j = 1: n_levels
    ims_slice = [];
    for i = 1:n_subj
        sl = x{i,j}(:,:,middle_slice);
        mag_factor = 4 / 2.^(j-1);
        ims_slice = cat(2, ims_slice, linear_interp_2d(sl, mag_factor));
    end
    ims = cat(3, ims, ims_slice);
end