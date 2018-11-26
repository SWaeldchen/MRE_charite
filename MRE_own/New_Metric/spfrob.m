function [ n ] = spfrob( A )
%SPARSE_FROB Summary of this function goes here
%   Detailed explanation goes here

n = trace(A'*A);

end

