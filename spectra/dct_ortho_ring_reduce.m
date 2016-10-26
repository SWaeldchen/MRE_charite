function y = dct_ortho_ring_reduce(x, superFactor)
sz = size(x);
if numel(sz) < 3
    d3 = 1;
else 
    d3 = sz(3);
end
for n = 1:d3
    [b,a] = butter(4, 1/superFactor);
    xi = x; %dct(x);
    xi_filt = filter(b, a, xi);
    xj = permute(xi_filt, [2 1 3]); %dct(xi_filt');
    xj_filt = filter(b, a, xj);
    %xi2 = idct(xj_filt)';
    %y = idct(xi2);
    y = permute(xj_filt, [2 1 3]);
end
