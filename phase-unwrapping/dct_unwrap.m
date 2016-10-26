function w_u = dct_unwrap(w, dims)
w = double(w);
w = (w - min(w(:))) ./ (max(w(:)) - min(w(:))) *2*pi;
sz = size(w);
w_u = zeros(sz);
if (numel(sz) < 6)
    d6 = 1;
else
    d6 = sz(6);
end
if (numel(sz) < 5)
    d5 = 1;
else
    d5 = sz(5);
end
if (numel(sz) < 4)
    d4 = 1;
else
    d4 = sz(4);
end
if (numel(sz) < 3)
    d3 = 1;
else
    d3 = sz(3);
end
for f = 1:d6
    for c = 1:d5
        for t = 1:d4
            for z = 1:d3
                w_u(:,:,z,t,c,f) = unwrap(w(:,:,z,t,c,f));
            end
        end
    end
end

end

function w_u = unwrap(w)
    sz = size(w);
    cosx = cos(w);
    sinx = sin(w);
    [x, y] = meshgrid(1:sz(2), 1:sz(1));
    mask = x.^2 + y.^2;
    
    term1 = sinx;
    term1 = dct2(term1);
    term1 = term1 .* mask;
    term1 = idct2(term1);
    term1 = term1 .* cosx;
    term1 = dct2(term1);
    term1 = term1 ./ mask;
    term1 = idct2(term1);
    
    term2 = cosx;
    term2 = dct2(term2);
    term2 = term2 .* mask;
    term2 = idct2(term2);
    term2 = term2 .* sinx;
    term2 = dct2(term2);
    term2 = term2 ./ mask;
    term2 = idct2(term2);
    
    w_u = term1 - term2;
end
