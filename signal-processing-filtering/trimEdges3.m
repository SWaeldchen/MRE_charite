function [y] = trimEdges3(x, margin)

y = x(margin(1)+1:end-margin(1), margin(2)+1:end-margin(2), margin(3)+1:end-margin(3));