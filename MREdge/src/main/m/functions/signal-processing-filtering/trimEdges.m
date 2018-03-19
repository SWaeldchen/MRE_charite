function [y] = trimEdges(x, margin)

d = size(x);
for n = 1:d-1
    x = x(margin:end-margin+1,d(2:end));
    shiftdim(x,1);
    shiftdim(d,1);
end
y = shiftdim(x,1);