function x = strip_neighbors(x) 
neighbors = find(diff(x) == 1); 
neighbors(neighbors==numel(x)) = [];
x(neighbors+1) = [];