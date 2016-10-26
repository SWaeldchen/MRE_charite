function [filters, montage, spectra] = collect_dt_filters(dim)
J = log(dim) / log(2) - 3;
fullsize = 4*2^(J+1);
halfsize = fullsize/2;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
filters = cell(J, 2, 2, 3);
montage = [];
spectra = [];
for m = 2:J
    L = 4*2^(m+1);
    N = L/2^J;
    x = zeros(L, L);
    w = cplxdual2D(x, m, Faf, af);
    for n = 1:2
        for p = 1:2
            for q = 1:3
                w_temp = w;
                w_temp{m}{n}{p}{q}(round(N/2), round(N/2)) = 1;
                filters{m}{n}{p}{q} = circshift(icplxdual2D(w_temp, m, Fsf, sf), [2^m, 2^m]);
                pad = simplepad(filters{m}{n}{p}{q}, [fullsize fullsize]);
                montage = cat(3, montage, pad);
                spectra_full = abs(fftshift(fft2(pad)));
                spectrum1 = zeros(size(spectra_full));
                spectrum2 = zeros(size(spectra_full));
                if (q == 1 || q == 3)
                    spectrum1(:,1:halfsize) = spectra_full(:,1:halfsize);
                    spectrum2(:,halfsize+1:end) = spectra_full(:,halfsize+1:end);
                else
                    spectrum1(1:halfsize,:) = spectra_full(1:halfsize,:);
                    spectrum2(halfsize+1:end,:) = spectra_full(halfsize+1:end,:);
                end
                spectra = cat(3, spectra, spectrum1, spectrum2);
            end
        end
    end
end
