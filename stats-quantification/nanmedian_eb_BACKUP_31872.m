function [m, used] = nanmedian_eb(x, thresh)

if nargin < 2
    thresh = 0;
end
sz = size(x);

if numel(x) < 4
    d4 = 1;
    if numel(x) < 3
        d3 = 1;
    else
        d3 = sz(3);
    end
else
    d4 = sz(4);
end

m = zeros(1, d4);
used = zeros(1, d4);

for n = 1:d4
    x_vec = abs(vec(x(:,:,:,n)));
    x_vec(x_vec < thresh) = nan;
    x_valid = x_vec(~isnan(x_vec));
    m_n = median(x_valid);
    used(n) = numel(x_valid) / numel(x_vec);
    m(n) = m_n;
end