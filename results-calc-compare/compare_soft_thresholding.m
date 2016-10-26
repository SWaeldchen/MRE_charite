function [d, montages] = compare_soft_thresholding(wm, wj)

d = cell(4, 4, 3);
montages = cell(4, 4);

% tree, level, image type

d{1, 1, 1} = wm{2}{1}{1};
d{1, 1, 2} = wj.get(0).get(0);
d{1, 1, 3} = d{1,1,1} - d{1,1,2};
montages{1,1} = cat(2, d{1,1,1}, d{1,1,2}, d{1,1,3});

d{2, 1, 1} = wm{2}{2}{1};
d{2, 1, 2} = wj.get(1).get(0);
d{2, 1, 3} = d{2,1,1} - d{2,1,2};
montages{2,1} = cat(2, d{2,1,1}, d{2,1,2}, d{2,1,3});

d{3, 1, 1} = wm{2}{1}{2};
d{3, 1, 2} = wj.get(2).get(0);
d{3, 1, 3} = d{3,1,1} - d{3,1,2};
montages{3,1} = cat(2, d{3,1,1}, d{3,1,2}, d{3,1,3});


d{4, 1, 1} = wm{2}{2}{2};
d{4, 1, 2} = wj.get(3).get(0);
d{4, 1, 3} = d{4,1,1} - d{4,1,2};
montages{4,1} = cat(2, d{4,1,1}, d{4,1,2}, d{4,1,3});

for i = 1:2
    for j = 1:2
        for k = 1:3
            index = (j-1)*2 + (i);
            im1 = wm{1}{i}{j}{k};
            %im2 = wj.get(index-1).get(k);
            im2 = wj.get(index-1).get(1);
            %im2 = zeros(size(im1));
            d{index,k+1,1} = im1;
            d{index,k+1,2} = im2;
            d{index,k+1,3} = im1 - im2;
            montages{index,k+1} = cat(2, im1, im2, im1-im2);
        end
    end
end
