function [ A ] = moving_avg_mat(N, k, isClosed)
%MOVING_AVG Summary of this function goes here
%   Detailed explanation goes here

if(isClosed)
    
    A = sparse(N, N);
    x = 1:N;
    y = 1:N;
    
    A((mod(x-y',N)>=0)&(mod(x-y',N)<k)) = 1;
    
else
    A = sparse(N-k+1, N);

    x = 1:N;
    y = 1:N-k+1;

    A((x>=y')&(x<y'+k)) = 1;
end

end

