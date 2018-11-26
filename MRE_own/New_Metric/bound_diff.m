function [ d ] = bound_diff(u, b)
%BOUND_DIFF Summary of this function goes here
%   Detailed explanation goes here


d = zeros(length(u),1);

d(1) = u(1) - b(1);
d(end) = u(end) - b(end);


end

