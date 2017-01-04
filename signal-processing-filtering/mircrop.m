function x_mir = mir(x)

nd = ndims(x);
x_mir = shiftdim(x, 2);
orig_dim = (size(x_mir, 1) + 2 ) / 3;
x_mir =  x_mir(orig_dim:orig_dim*2-1,:,:,:,:,:,:,:,:,:,:); % kludge for nd, obviously
x_mir = shiftdim(x_mir, nd-2);
