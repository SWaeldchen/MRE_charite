function [ind] = corners(sz)
%CORNERS Gives back a logical array indicating the corners of a d-dim
%array.

corners = 0;

for dim = 1:length(sz)
    
    dimVec = ones(1,length(sz));
    dimVec(dim) = sz(dim);
    endVec = zeros(dimVec);
    
    endVec(1) = true; endVec(end) = true;
    
    corners = corners + endVec;
    
end

corners = corners >= 2;

ind = ndSparse(corners, sz);


end

