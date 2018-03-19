function w_d = duplicate_wavelet_transform_zeros_1d_real(w)

J = numel(w);
w_d = w;
for j = 1:J
    % loop thru subbands
    w_d{j} = zeros(size(w_d{j}));
end
