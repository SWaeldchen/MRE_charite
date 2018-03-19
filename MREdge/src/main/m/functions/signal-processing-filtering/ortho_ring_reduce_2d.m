function x = ortho_ring_reduce_2d(x, superFactor)

    sz = size(x);
    [b,a] = butter(4, 1/superFactor);
    x_filt = filter(b, a, x);
    x = shiftdim(x_filt, 1);
    x_filt = filter(b, a, x);
    x = shiftdim(x_filt, numel(sz)-1);


end
