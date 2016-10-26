function x = zero_to_nan(x)

x(find(x==0)) = nan;