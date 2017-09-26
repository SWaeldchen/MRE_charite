function u = den_2d_preunwrap(u)

u_resh = resh(u, 3);
u_resh = dtdenoise_xy_pca_mad_u(u_resh, 1, 3);
u = reshape(u_resh, size(u));
