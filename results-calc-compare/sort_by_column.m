function v = sort_by_column(u, col)


if nargin < 2
    col = 1;
end

sz = size(u);

[~, I] = sort(u);
sorting_col = I(:,col);

v = zeros(size(u));

for n = 1:sz(2)
    u_vec = u(:,n);
    v(:,n) = u_vec(sorting_col);
end

