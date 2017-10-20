function y = wavelet_dering_real(x, thresh)

if nargin < 2
    thresh = 500;
end
[af, sf] = farras;
w_r = dwt2D(x, 1, af);
for n = 1:3
    temp = w_r{1}{n};
    rings = abs(temp)>thresh;
    temp(rings) = 0;
    w_r{1}{n} = temp;
end
y = idwt2D(w_r, 1, sf);