function [ S ] = db4inv( s, d )
    N = 2*numel(s);
    S = zeros(N,1);
    S(2:2:N) = d + sqrt(3)/4*s;
    S(1:2:N-1) = s - sqrt(3)*S(2:2:N);
end


