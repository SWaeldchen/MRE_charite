function e = get_stack_entropy(x)

sz = size(x);
e = zeros(sz(3),1);
for n = 1:sz(3)
    e(n) = entropy(normalizeImage(x(:,:,n)));
end