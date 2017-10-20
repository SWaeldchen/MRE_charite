function y = wavelet_dering_real(x, thresh)

if nargin < 2
    thresh = 500;
end
[af, sf] = get_db2;
%[af, sf] = farras;
w_r = dwt2D(x, 2, af);
for n = 1:3
    %temp = w_r{2}{n};
    %rings = abs(temp)>thresh;
    %temp(rings) = 0;
    %w_r{2}{n} = temp;
    w_r{2}{n} = zeros(size(w_r{2}{n}));
end
y = idwt2D(w_r, 2, sf);