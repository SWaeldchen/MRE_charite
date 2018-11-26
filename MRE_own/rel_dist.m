function [ relDist ] = rel_dist(y1, y2)
%REL_DIST Summary of this function goes here
%   Detailed explanation goes here

if size(y1) ~= size(y2)
    error('Vectors must match in size')
end

x = (y1-y2).*conj(y1-y2)./((y1+y2+0.001).*conj(y1+y2+0.001));

relDist = sum(x)/length(x);

end

