function [rer_new, er_new] = rer_3d(x)
tic
sz = size(x);
er = zeros(sz(1)-8, sz(2)-8, sz(3));
rer = zeros(size(er));
for k = 1:sz(3)
    %display(['Slice ',num2str(k),' of ',num2str(sz(3))]);
    fprintf([int2str(k) ' '],k);
    for i = 1:sz(1)-8
        for j = 1:sz(2)-8 % DONT NEED TO NORMALIZE DCT BECAUSE ITS RATIO
            square = x(i:i+7, j:j+7, k);
            dct_square = dct2(square);
            num = dct_square(2:end,2:end);
            denom = dct_square(1,1);
            red_num = dct_square(1:5,1:5);
            red_num(1,1) = 0;
            er(i,j,k) = sum(num(:).^2) / denom.^2;
            rer(i,j,k) = sum(red_num(:).^2) / denom.^2;
        end
    end
end

rer_new = zeros(size(x));
rer_new(1:size(rer,1),1:size(rer,2),1:size(rer,3))=rer;

er_new = zeros(size(x));
er_new(1:size(er,1),1:size(er,2),1:size(er,3))=er;


toc                                     
end
