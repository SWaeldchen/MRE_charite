function x_mir = mir(x, n_slcs)

x_resh = resh(x, 4);
z_indices = [(n_slcs+1):-1:2, 1:1:size(x_resh,3), size(x_resh,3):-1:n_slcs];

x_mir = x_resh(:,:,z_indices,:);