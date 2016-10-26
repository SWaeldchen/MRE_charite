function ims = diffdemo_for_ivan

lena = double(imread('lena.tif'));
lena = lena + randn(size(lena))*256*0.05;

gauss1 = fspecial('gaussian', 5, 1.3);
gauss2 = fspecial('gaussian', 9, 2.7);

[dx_fd1, dy_fd1] = gradient(conv2(lena, gauss1, 'same'));
[dx_fd2, dy_fd2] = gradient(conv2(lena, gauss2, 'same'));
[dx_dwt1, dy_dwt1] = cdwt_diff_ogs_2D(lena, 1);
[dx_dwt2, dy_dwt2] = cdwt_diff_ogs_2D(lena, 2);

xcat = cat(2, dx_fd1, dx_dwt1, dx_fd2, dx_dwt2);
ycat = cat(2, dy_fd1, dy_dwt1, dy_fd2, dy_dwt2);

montage = cat(1, xcat, ycat);
montage = montage - min(montage(:));

imshow(montage / max(montage(:)));
title('columns: 1) FD Gradient sigma = 1.3 2) CDWT Gradient Level 1 3) FD Gradient sigma = 2.6 4) CDWT Level 2')

ims = {dx_fd1, dx_dwt1, dx_fd2, dx_dwt2, dy_fd1, dy_dwt1, dy_fd2, dy_dwt2};
