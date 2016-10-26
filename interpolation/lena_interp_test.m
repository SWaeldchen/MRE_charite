w = cplxdual2D(lena, 3, Faf, af);
lena2 = imresize(lena, 2);
y = cplxdual2D(lena2, 1, Faf, af);
z = duplicate_wavelet_transform_zeros(y);
% just put lena images in the lo-pass positions
for m = 1:2
    for n = 1:2
        z{2}{m}{n} = lena;
    end
end
lena_up_1 = icplxdual2D(z, 1, Fsf, sf);
% add actual cdwt two levels down
w = cplxdual2D(lena, 2, Faf, af);
y2 = cplxdual2D(lena2, 3, Faf, af);
z2 = duplicate_wavelet_transform_zeros(y2);
for m = 1:2
    for n = 1:2
        z2{4}{m}{n} = w{3}{m}{n};
    end
end
for m = 1:2
    for n = 1:2
        for p = 1:3
            z2{3}{m}{n}{p} = w{2}{m}{n}{p};
            z2{2}{m}{n}{p} = w{1}{m}{n}{p};
        end
    end
end
lena_up_2 = icplxdual2D(z2, 3, Fsf, sf);
% project coefficients onto new interp
y3 = cplxdual2D(lena2, 1, Faf, af);
z3 = duplicate_wavelet_transform_zeros(y3);
for m = 1:2
    for n = 1:2
        z3{2}{m}{n} = lena;
    end
end
for m = 1:2
    for n = 1:2
        for p = 1:3
            z3{1}{m}{n}{p} = imresize(w{1}{m}{n}{p},2);
        end
    end
end
lena_up_3 = icplxdual2D(z3, 1, Fsf, sf);
% interp, decompose, then swap lo pass
y4 = cplxdual2D(lena2, 1, Faf, af);
for m = 1:2
    for n = 1:2
        y4{2}{m}{n} = lena;
    end
end
lena_up_4 = icplxdual2D(y4, 1, Fsf, sf);
openImage(cat(3, lena2, lena_up_1, lena_up_2, lena_up_3, lena_up_4), MIJ);
openImage(cat(3, pwrspec(lena2), pwrspec(lena_up_1), pwrspec(lena_up_2), pwrspec(lena_up_3), pwrspec(lena_up_4)), MIJ);