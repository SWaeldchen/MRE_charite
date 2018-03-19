function w = center_udwt(v)

J = numel(v) - 1;
w = cell(size(v));
max_length = length(v{J});
max_length_mid = max_length / 2;
for n = 1:J
    w{n} = zeros(max_length, 1);
    curr_length = length(v{n});
    curr_length_mid = curr_length / 2;
    lo = max_length_mid - curr_length_mid +1;
    hi = max_length_mid + curr_length_mid;
    w{n}( lo:hi ) = v{n};
end
w{J+1} = v{J+1};