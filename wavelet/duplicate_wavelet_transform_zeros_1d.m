function w_d = duplicate_wavelet_transform_zeros_1d(w)

szw = size(w);
J = szw(2);
w_d = w;
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        w_d{j}{s1} = zeros(size(w_d{j}{s1}));
    end
end
