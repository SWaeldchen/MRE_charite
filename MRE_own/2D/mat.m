function [ matr ] = mat( vec, n,m )
%MATR Summary of this function goes here
%   Detailed explanation goes here

matr = zeros(m,n);

matr(:) = vec;

matr = matr';

end

