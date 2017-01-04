function x_mir = mir(x)

nd = ndims(x);

x_flip = shiftdim(x, 2);
x_flip = flipud(x_flip);
x_flip = x_flip(1:end-1,:,:,:,:,:,:,:,:,:,:); % kludge for nd, obviously
x_flip = shiftdim(x_flip, nd-2);

x_mir = cat(3, x_flip, x, x_flip); 