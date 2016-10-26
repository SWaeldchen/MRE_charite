function x_centered = center_slice_means(x)

sz = size(x);

if numel(sz) == 5
    x_centered = center_slice_means_5d(x);
elseif numel(sz) == 4
    x_centered = center_slice_means_4d(x);
elseif numel(sz) == 3
    x_centered = center_slice_means_3d(x);
end


end

function x_centered = center_slice_means_5d(x)
    x_centered = zeros(size(x));
    for n = 1:size(x,5)
        x_centered(:,:,:,:,n) = center_slice_means_4d(x(:,:,:,:,n));
    end
end

function x_centered = center_slice_means_4d(x)
    x_centered = zeros(size(x));
    for n = 1:size(x,4)
        x_centered(:,:,:,n) = center_slice_means_3d(x(:,:,:,n));
    end
end

function x_centered = center_slice_means_3d(x)
    x_centered = zeros(size(x));
    for n = 1:size(x,3)
        slice_r = real(x(:,:,n));
        slice_mean_r = mean(slice_r(slice_r ~= 0));
        slice_r = slice_r - slice_mean_r;        
        
        slice_i = imag(x(:,:,n));
        slice_mean_i = mean(slice_i(slice_i ~= 0));
        slice_i = slice_i - slice_mean_i;
        
        x_centered(:,:,n) = slice_r + 1i*slice_i;
    end
end


