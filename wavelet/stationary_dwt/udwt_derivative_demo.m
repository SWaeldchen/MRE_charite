lena = double(imread('lena.tif'));

% fd gradient
[lena_fd_xgrad, lena_fd_ygrad] = gradient(lena);

% wavelet gradient
[h0, h1, g0, g1] = daubf(3);
J = 3;
w = udwt2D(lena, J, h0, h1);
w_lo = w{J+1};
[w_x, w_y] = gradient(w_lo);
w{J+1} = w_x;
lena_wavelet_xgrad = iudwt2D(w, J, g0, g1);
w{J+1} = w_y;
lena_wavelet_ygrad = iudwt2D(w, J, g0, g1);

montage_x = cat(2, lena_fd_xgrad, lena_wavelet_xgrad);
montage_y = cat(2, lena_fd_ygrad, lena_wavelet_ygrad);
montage = cat(1, montage_x, montage_y);

figure(); imshow(montage, []); title('Finite Differences on left, Wavelets on right');
