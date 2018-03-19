function [ s, d ] = haar( S )
    N = length(S);
    s = S(1:2:N-1);
    d = S(2:2:N) - S(1:2:N-1);
end

