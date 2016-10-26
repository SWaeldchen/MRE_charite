function [lp] = cat_wavelet_real(w)
levels = size(w, 2) - 1;
lp = w{levels+1};
for p = levels:-1:1
    lev = catlevel(p, w, lp);
    lp = lev;
end
end

function y = catlevel(level, decomp, lowpass)
    cat1 = cat(2, lowpass, decomp{level}{1});
    cat2 = cat(2, decomp{level}{2}, decomp{level}{3});
    y = cat(1, cat1, cat2);
end
    
            