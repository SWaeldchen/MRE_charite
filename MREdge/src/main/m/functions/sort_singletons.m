function [d3, d4, d5, d6] = sort_singletons(sz)
% sorts singleton dimensions up to 6d
if numel(sz) < 6
    d6 = 1;
else
    d6 = sz(6);
end
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end
if numel(sz) < 4
    d4 = 1;
else
    d4 = sz(4);
end
if numel(sz) < 3
    d3 = 1;
else
    d3 = sz(3);
end