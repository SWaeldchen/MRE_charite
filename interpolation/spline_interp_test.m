function y = spline_interp_test(x, fac)
sz = size(x);
y = zeros(sz(1)*fac, sz(2));
for n = 1:sz(2)
    x_row = x(:,n);
    num_ = 1:numel(x_row);
	num_xtra = find(abs(x)< 0.9)';
	size(num_)
	size(num_xtra)
	num_ = cat(2, num_, num_xtra-0.25, num_xtra+0.25);
	num_ = sort(num_);
	display(num_)
    num_div = [1:(1/fac):numel(x_row), zeros(1, fac-1)];
    y(:,n) = permute(spline(num_(1:32), x_row, num_div), [2 1]);
end
y(isnan(y)) = 0;
