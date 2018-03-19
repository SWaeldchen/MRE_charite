function w = decenter_udwt(v, v_orig)

J = numel(v) - 1;
w = cell(size(v));
max_length = length(v{J});
max_length_mid = max_length / 2;
for n = 1:J
    w{n} = zeros(size(v_orig{n}));
    curr_length = length(v_orig{n});
    curr_length_mid = curr_length / 2;
    lo = max_length_mid - curr_length_mid +1;
    hi = max_length_mid + curr_length_mid;
    w{n} = v{n}( lo:hi );
end
w{J+1} = v{J+1};