function [w_cat] = cat_wavelet_matlab(w)
cats = cell(2, 2);
levels = size(w, 2) - 1;
for m = 1:2
    for n = 1:2
        lp = w{levels+1}{m}{n};
        for p = levels:-1:1
            lev = catlevel(p, w, m, n, lp);
            lp = lev;
        end
        cats{m,n} = lp;
    end
end
cat1 = cat(2, cats{1,1}, cats{1,2});
cat2 = cat(2, cats{2,1}, cats{2,2});
w_cat = cat(1, cat1, cat2);
end

function y = catlevel(level, decomp, m, n, lowpass)
    cat1 = cat(2, lowpass, decomp{level}{m}{n}{1});
    cat2 = cat(2, decomp{level}{m}{n}{2}, decomp{level}{m}{n}{3});
    y = cat(1, cat1, cat2);
end
    
            