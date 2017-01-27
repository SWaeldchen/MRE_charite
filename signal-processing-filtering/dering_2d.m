function [v, t_grid] = dering_2d(u, thresh_pts, thresh_max, thresh_vals)

sz = size(u);
v = zeros(sz);
for n = 1:sz(3)
    sl = u(:,:,n);
    t_grid = gen_thresh_grid_2d(sl, thresh_pts, thresh_max, thresh_vals);
    logft_sl = log(abs(fftshift(fft2(sl))));
    thresh = (logft_sl > t_grid);
    ft_sl = fftshift(fft2(sl));
    ft_sl(thresh) = 0;
    v(:,:,n) = ifft2(ifftshift(ft_sl));
end


