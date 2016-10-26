function x = cdwt_interp_2d(x, fac)
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
sz = size(x);
pad1 = nextpwr2(sz(1));
pad2 = nextpwr2(sz(2));
pad = max(pad1, pad2);
x = simplepad(x, [pad pad]);
for n = 1:(log(fac)/log(2))
    w = cplxdual2D(imresize(x, 2), 1, Faf, af);
    w_d = duplicate_wavelet_transform_zeros(w);
    for m = 1:2
        for n = 1:2
            w_d{2}{m}{n} = x;
        end
    end
    x = icplxdual2D(w_d, 1, Fsf, sf);
end
x = x(1:sz(1)*fac, 1:sz(2)*fac);