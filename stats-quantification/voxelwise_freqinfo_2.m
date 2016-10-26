function [er, ent, rer, rent] = voxelwise_freqinfo_2(x)
tic
sz = size(x);
er = zeros(sz(1)-8, sz(2)-8, sz(3));
ent = zeros(size(er));
rer = zeros(size(er));
rent = zeros(size(rer));
for k = 1:sz(3)
    display(['Slice ',num2str(k),' of ',num2str(sz(3))]);
    for i = 1:sz(1)-8
        for j = 1:sz(2)-8 % DONT NEED TO NORMALIZE DCT BECAUSE ITS RATIO
            square = x(i:i+7, j:j+7);
            dct_square = dct2(square);
            ent(i,j,k) = entropy(normalise(square));
            rent(i,j,k) = entropy(normalise(dct_square));
            num = dct_square(2:end,2:end);
            denom = dct_square(1,1);
            red_num = dct_square(2:5,2:5);
            er(i,j,k) = sum(num(:)) / denom;
            rer(i,j,k) = sum(red_num(:)) / denom;
        end
    end
end

toc                                                                                                                                                                                                                                                                                                                            
