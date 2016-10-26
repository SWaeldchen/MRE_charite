%% demo_PR2
% Verify perfect reconstruction property
% over a range of K, N, and J

for K = 1:4;

    % Get filters
    [h0, h1, g0, g1] = daubechies_filters(K);

    for N = 300:320
        x = rand(1,N);
        for J = 1:5
            w = dwt(x, J, h0, h1);
            y = idwt(w, J, g0, g1);
            y = y(1:N);
            err = x - y;
            max(abs(err))
        end
    end
end