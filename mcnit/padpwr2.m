function y = padpwr2(x)

[x_resh, n_slcs] = resh(x, 3);
sz = size(x);
sz_i = nextpwr2(sz(1));
sz_j = nextpwr2(sz(2));
y = zeros([sz_i sz_j n_slcs]);
y(1:sz(1), 1:sz(2), :) = x_resh;
sz_y = [sz_i sz_j sz(3:end)];
y = reshape(y, sz_y);