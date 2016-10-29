function m = ucdwt_level_one_montage(w)

for i = 1:2
    for j = 1:2
        for k = 1:3
            row1 = cat(2, normalize_image(w{2}), normalize_image(w{1}{1}));
            row2 = cat(2, normalize_image(w{1}{2}), normalize_image(w{1}{3}));

m = cat(1, row1, row2);