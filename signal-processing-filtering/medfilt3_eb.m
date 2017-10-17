function y = medfilt3_eb(x, win)

[x_resh, n_vols] = resh(x, 4);

win = floor(win/2);
y_resh = zeros(size(x_resh));
range_i = win(1)+1:size(x,1)-win(1);
range_j = win(2)+1:size(x,2)-win(2);
range_k = win(3)+1:size(x,3)-win(3);

for n = 1:n_vols
    disp(n)
    x_temp = x_resh(:,:,:,n);
    for i = range_i
        for j = range_j
            for k = range_k
                y_resh(i,j,k,n) = median(vec(x_temp( (i-win(1)):(i+win(1)),(j-win(2)):(j+win(2)), (k-win(3)):(k+win(3)) )));
            end
        end
    end
end

y = reshape(y_resh, size(x));