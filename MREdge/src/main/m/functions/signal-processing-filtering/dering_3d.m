function [v, threshed_spec, t_grid, gridpts] = dering_3d(u, thresh_pts, thresh_vals)

    [t_grid, gridpts] = gen_thresh_grid_3d(u, thresh_pts, thresh_vals);
    logft_u = log(abs(fftshift(fftn(u))));
    thresh = (logft_u > t_grid);
    ft_u = fftshift(fftn(u));
    ft_u(thresh) = 0;
    threshed_spec = log(ft_u);
    v = ifftn(ifftshift(ft_u));


