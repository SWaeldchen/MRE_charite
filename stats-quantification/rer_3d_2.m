function [rer, er] = rer_3d_2(x)
if ndims(x) == 2
	d3 = 1;
else
	d3 = sz(3);
end
sz = size(x);
er = zeros(sz(1)-8, sz(2)-8, d3);
rer = zeros(size(er));

for k = 1:d3
    display(['Slice ',num2str(k),' of ',num2str(d3)]);
    for i = 1:sz(1)-8
        for j = 1:sz(2)-8 % DONT NEED TO NORMALIZE DCT BECAUSE ITS RATIO
            square = x(i:i+7, j:j+7, k);
            dct_square = dct2(square);
            num = dct_square(2:end,2:end);
            denom = dct_square(1,1);
            red_num = dct_square([2, 3, 9, 10, 17]);
            red_num(1,1) = 0;
            er(i,j,k) = sum(num(:).^2) / denom.^2;
            rer(i,j,k) = sum(red_num(:).^2) / denom.^2;
        end
    end
end                                                                                                                                                                                                                                                                                                                            
