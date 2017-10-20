lena = double(imread('lena.tif'));

% fd gradient
[lena_fd_xgrad, lena_fd_ygrad] = gradient(lena);
lena_fd_lap = lap(lena);

% wavelet gradient
[h0, h1, g0, g1] = daubf(3);
J = 3;
w = udwt2D(lena, J, h0, h1);
w_lo = w{J+1};
[w_x, w_y] = gradient(w_lo);
w_lap = lap(w{J+1});
w{J+1} = w_x;
lena_wavelet_xgrad = iudwt2D(w, J, g0, g1);
w{J+1} = w_y;
lena_wavelet_ygrad = iudwt2D(w, J, g0, g1);
w{J+1} = w_lap;
lena_wavelet_lap = iudwt2D(w, J, g0, g1);

% kludge because udwt leaves the image a little bigger
lena_xgrad_pad = zeros(517, 517);
lena_xgrad_pad(1:512, 1:512) = lena_fd_xgrad;

lena_ygrad_pad = zeros(517, 517);
lena_ygrad_pad(1:512, 1:512) = lena_fd_ygrad;

lena_lap_pad = zeros(517, 517);
lena_lap_pad(1:512, 1:512) = lena_fd_lap;

montage_x = cat(2, lena_xgrad_pad, lena_wavelet_xgrad);
montage_y = cat(2, lena_ygrad_pad, lena_wavelet_ygrad);
montage_lap = cat(2, lena_lap_pad, lena_wavelet_lap);
montage = cat(1, montage_x, montage_y, montage_lap);

figure(); imshow(montage, []); title('Finite Differences on left, Wavelets on right');
