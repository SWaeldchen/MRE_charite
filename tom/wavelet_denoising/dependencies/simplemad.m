function mad = simplemad(vec)
    vec_nonan = vec(~isnan(vec));
    vec_median = median(vec_nonan);
    mad = median(abs(vec_nonan - vec_median));
end