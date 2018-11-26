function [ result ] = median_mult(M, x)
%MEDIAN_MULT Summary of this function goes here
%   Detailed explanation goes here

mx = M*x;

[nr,nc] = size(M);

signMx = sign(M).*mx;

[signMx, ind] = sort(signMx,1);
% 

% ind+nr*(0:nc-1)

weights = abs(M(ind+nr*(0:nc-1)));

cumSum = cumsum(weights,1);

cumSum(cumSum > cumSum(end,:)/2) = 0;

[~, ind] = max(cumSum, [], 1);

result = signMx(ind+nr*(0:nc-1))';

end

