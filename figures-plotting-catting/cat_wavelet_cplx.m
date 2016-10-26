function [w_cat] = cat_wavelet_cplx(w)
cats = cell(2, 1);
levels = size(w, 2) - 1;
for n = 1:2
    lp = abs(w{levels+1}{1}{n} + 1i*w{levels+1}{2}{n});
    for p = levels:-1:1
        lev = catlevel(p, w, n, lp);
        lp = lev;
    end
    cats{n} = lp;
end

w_cat = cat(1, cats{1}, cats{2});
end

function y = catlevel(level, decomp, n, lowpass)
    cat1 = cat(2, lowpass, abs(decomp{level}{1}{n}{1} + 1i*decomp{level}{2}{n}{1}));
    cat2 = cat(2, abs(decomp{level}{1}{n}{2} + 1i*decomp{level}{2}{n}{2}),...
        abs(decomp{level}{1}{n}{3} + 1i*decomp{level}{2}{n}{3}));
    y = cat(1, cat1, cat2);
end
    
            