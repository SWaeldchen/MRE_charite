function w_d = duplicate_wavelet_transform_zeros(w)

szw = size(w);
J = szw(2);
w_d = w;
for j = 1:J-1
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:3
                w_d{j}{s1}{s2}{s3} = zeros(size(w_d{j}{s1}{s2}{s3}));
            end
        end
    end
end
for s1 = 1:2
    for s2 = 1:2
        w_d{J}{s1}{s2} = zeros(size(w_d{J}{s1}{s2}));
    end
end