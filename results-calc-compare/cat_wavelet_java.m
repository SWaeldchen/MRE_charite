function [w_cat] = cat_wavelet_java(w)
cats = cell(4, 1);
levels = (w.get(0).size() - 1) / 3;
for k = 1:4
    lp = w.get(k-1).get(0)';
    for m = 1:levels
        index = (m-1)*3+1;
        cat1 = cat(2, lp, w.get(k-1).get(index)');
        cat2 = cat(2, w.get(k-1).get(index+1)', w.get(k-1).get(index+2)');
        cat_ = cat(1, cat1, cat2);
        lp = cat_;
    end
    cats{k} = lp;
end
cat1 = cat(2, cats{1}, cats{2});
cat2 = cat(2, cats{3}, cats{4});
w_cat = cat(1, cat1, cat2);
end

function y = catlevel(level, decomp, m, n, lowpass)
    cat1 = cat(2, lowpass, decomp{level}{m}{n}{1});
    cat2 = cat(2, decomp{level}{m}{n}{2}, decomp{level}{m}{n}{3});
    y = cat(1, cat1, cat2);
end
    
            