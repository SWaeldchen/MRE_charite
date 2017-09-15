decomps = zeros(size(x, 1), size(x,2), min(size(x,1), size(x,2)));

for n = 1:min(size(S,1), size(S,2))
    S_temp = S;
    S_temp(1:n-1, 1:n-1) = 0;
    S_temp(n+1:end, n+1:end) = 0;
    decomps(:,:,n) = U*S_temp*V';
end