function y = spatially_adaptive_thresh(Y)

[x_resh, n_slcs] = resh(Y, 3);
Z = zeros(size(Y));
for n = 1:n_slcs
    x_slc = x_resh(:,:,n);
    x_resh(:,:,n) = thresh_slice(x_slc);
end

y = reshape(x_resh, size(Y));

end

function x_thresh = thresh_slice(x_slc)
    weights = get_weights(x_slc);
    x_v = x_slc(:);
    x_thresh = x_v;
    [weights_sort, weights_ind] = sort(weights(:));
    half_window = 25;
    n_weights = numel(weights_sort);
    window_center = 26;
    while window_center < n_weights - half_window
        window = [(window_center-half_window):1:(window_center+half_window)];
        window_indices = weights_ind(window);
        window_vals = x_v(window_indices);
        window_sigma_hat = visushrink_eb(window_vals);
        window_thresh = soft(window_vals, window_sigma_hat);
        x_thresh(weights_ind(window_center)) = window_thresh(26);
        window_center = window_center + 1;
        if mod(window_center, 1000) == 0
            disp([num2str(window_center), ' ', num2str(window_sigma_hat)]);
        end
    end
end

function weights = get_weights(x_slc)
    variance_coeffs = zeros(size(x_slc, 1), size(x_slc, 2), 8);
    variance_coeffs(2:end-1,2:end-1,1) = x_slc(1:end-2, 1:end-2);
    variance_coeffs(2:end-1,2:end-1,2) = x_slc(2:end-1, 1:end-2);
    variance_coeffs(2:end-1,2:end-1,3) = x_slc(3:end, 1:end-2);
    variance_coeffs(2:end-1,2:end-1,4) = x_slc(1:end-2, 2:end-1);
    variance_coeffs(2:end-1,2:end-1,5) = x_slc(3:end, 2:end-1);
    variance_coeffs(2:end-1,2:end-1,6) = x_slc(1:end-2, 3:end);
    variance_coeffs(2:end-1,2:end-1,7) = x_slc(2:end-1, 3:end);
    variance_coeffs(2:end-1,2:end-1,8) = x_slc(3:end, 3:end);
    base_value = repmat(x_slc, [1 1 8]);
    weights = sum((base_value - variance_coeffs).^2, 3);
end

