function y = medfilt2_eb(x, win)

win = floor(win/2);
y = zeros(size(x));
range_i = win(1)+1:size(x,1)-win(1);
range_j = win(2)+1:size(x,2)-win(2);

for i = range_i
    disp(i)
    for j = range_j
        y(i,j) = median(vec(x( (i-win(1)):(i+win(1)),(j-win(2)):(j+win(2)) )));
    end
end
