function x = ortho_ring_reduce(x, superFactor)

    sz = size(x);
    if numel(sz) == 4
        x = ortho_ring_reduce_4d(x, superFactor, sz);
        return;
    end
    if numel(sz) < 3
        d3 = 1;
    else 
        d3 = sz(3);
    end
    [b,a] = butter(4, 1/superFactor);
    for n = 1:numel(sz)
        x_filt = filter(b, a, x);
        x = shiftdim(x_filt, 1);
    end

end

function y = ortho_ring_reduce_4d(x, superFactor, sz)
    y = zeros(sz);
    [b,a] = butter(4, 1/superFactor);    
    for n = 1:sz(4)
        for m = 1:sz(3)
            x_temp = x(:,:,m,n);
            x_temp_filt_i = filter(b, a, x_temp);
            x_temp_permute = permute(x_temp_filt_i, [2 1]);
            x_temp_filt_j = filter(b,a,x_temp_permute);
            y(:,:,m,n) = permute(x_temp_filt_j, [2 1]);
        end
    end
end