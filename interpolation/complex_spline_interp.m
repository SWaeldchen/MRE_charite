function y_2 = spline_interp(x, fac)
sz = size(x);
y = zeros(sz(1)*fac, sz(2));
y_2 = zeros(sz(1)*fac, sz(2)*fac);
for n = 1:sz(2)
    x_row = x(:,n);
    num_ = 1:numel(x_row);
    num_div = [1:(1/fac):numel(x_row), zeros(1, fac-1)];
    y(:,n) = permute(spline(num_, x_row, num_div), [2 1]);
end
for n = 1:sz(1)*fac;
    y_col = y(n,:);
    num_ = 1:numel(y_col);
    num_div = [1:(1/fac):numel(y_col), zeros(1, fac-1)];
    y_2(n,:) = spline(num_, y_col, num_div);
end
y_2(isnan(y_2)) = 0;
