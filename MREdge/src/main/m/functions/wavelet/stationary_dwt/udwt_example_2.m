
for K = 1:4;
    % CONSTRUCT FILTERS
    [h0, h1, g0, g1] = daubf(K);

    % TEST PERFECT RECONSTRUCTION PROPERTY
    N = 779;
    x = rand(1,N);
    J = 5;
    w = udwt(x, J, h0, h1);
    y = iudwt(w, J, g0, g1);
    y = y(1:N);
    err = x - y;
    max(abs(err))
end
