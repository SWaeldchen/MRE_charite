function y = cell2cat(x)

y = [];
for n = 1:numel(x)
    y = cat(3, y, x{n});
end