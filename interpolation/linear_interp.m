function y = linear_interp(x, fac)
sz = size(x);
y = zeros(sz(1)*fac, sz(2));
for n = 1:sz(2)
    x_row = x(:,n);
    num_ = 1:numel(x_row);
    num_div = [1:(1/fac):numel(x_row), zeros(1, fac-1)];
    %y(:,n) = permute(interp1(num_, x_row, num_div), [2 1]);
    y(:,n) = interp1(num_, x_row, num_div)';
end
y(isnan(y)) = 0;