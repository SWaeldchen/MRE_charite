function [ S ] = haarInv( s, d )
    N = 2*numel(s);
    S = zeros(N,1);
    S(1:2:N-1) = s - d;
    S(2:2:N) = d + s;
end


