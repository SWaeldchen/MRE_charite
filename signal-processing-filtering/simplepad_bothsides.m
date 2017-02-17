function y = simplepad_bothsides(x, pad)
% in simplepad_bothsides, pad is number of added zeros
sz = size(x);
pad_sum = sz + 2*pad;
y = zeros(pad_sum);
y(pad(1)+1:end-pad(1), pad(2)+1:end-pad(2)) = x;
