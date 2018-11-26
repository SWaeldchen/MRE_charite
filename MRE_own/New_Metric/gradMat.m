function [ A ] = gradMat( N )
%GRADMAT Summary of this function goes here
%   Detailed explanation goes here


A = sparse(N-1,N);

A((1:N-1)'==1:N) = 1;
A((1:N-1)'==(1:N)-1) = -1;

end

