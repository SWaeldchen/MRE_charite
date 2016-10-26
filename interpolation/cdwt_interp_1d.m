function x = cdwt_interp_1d(x, fac)
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
pad = nextpwr2(x);
sz = numel(x);
x = simplepad(x, [pad 0]);
for n = 1:(log(fac)/log(2))
    w = dualtree(resample(x, 2, 1), 1, Faf, af);
    w_d = duplicate_wavelet_transform_zeros_1d(w);
    for p = 1:2
        %w_d{1}{p} = w{1}{p};
        w_d{2}{p} = x;
    end
    x = idualtree(w_d, 1, Fsf, sf);
end
x = x(1:sz*fac);