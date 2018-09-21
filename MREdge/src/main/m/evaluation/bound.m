function [ind] = bound(sz)
%gives back a sparse matrix indicating the boundary of a matrix, i.e. all
%entries belonging to the first/last column/row.

border = 0;

for dim = 1:length(sz)
    
    dimVec = ones(1,length(sz));
    dimVec(dim) = sz(dim);
    endVec = zeros(dimVec);
    
    endVec(1) = true; endVec(end) = true;
    
    border = border | endVec;
    
end

ind = ndSparse(border, sz);


end

