function [ s, d ] = db4( S );
    N = length(S);
    s = S(1:2:N-1) + sqrt(3)*S(2:2:N);
    d = S(2:2:N) - sqrt(3)/4*s;
end


