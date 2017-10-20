function y = wavelet_dering_cdwt(x, thresh, J)
if nargin < 3
    J = 2;
    if nargin < 2
        thresh = 500;
    end
end
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = cplxdual2D(x, J, Faf, af);
for j = 2:J
    for n = 1:2
        for p = 1:3
            re = w{j}{1}{n}{p};
            im = w{j}{2}{n}{p};
            smooth_re = medfilt3(re, [5, 5, 1]);
            smooth_im = medfilt3(im, [5, 5, 1]);
            C =  re + 1i*im;
            mag = abs(C);
            rings = mag>thresh;
            w{j}{1}{n}{p}(rings) = 0; %smooth_re(rings);
            w{j}{2}{n}{p}(rings) = 0; %smooth_im(rings);
        end
    end
end
y = icplxdual2D(w, J, Fsf, sf);