function [ y ] = normalise( x )

mn = min(x(:));
mx = max(x(:));

y = (x - mn) ./ (mx-mn);

end

