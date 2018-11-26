function [ A ] = laplace_op(N)
%LAPLACE_OP Summary of this function goes here
%   Detailed explanation goes here

A = sparse(N, N);

x = 1:N;
y = (1:N)';

A(x == y) = -2;
A(mod(x-y,N) == 1) = 1;
A(mod(x-y,N) == N-1) = 1;


end

