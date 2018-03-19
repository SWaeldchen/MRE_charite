function x = db2_interp_1d(x, fac)
%[af, sf] = get_haar();
[af, sf] = get_db2();
pad = nextpwr2(x);
sz = numel(x);
x = simplepad(x, [pad 0]);
for n = 1:(log(fac)/log(2))
    w = dwt(resample(x, 2, 1), 1, af);
    w_d = duplicate_wavelet_transform_zeros_1d_real(w);
    w_d{1} = w{1};
    w_d{2} = x;
    x = idwt(w_d, 1, sf);
end
x = x(1:sz*fac);