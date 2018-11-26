function [ Res ] = mat_diag(C)
%MAT_DIAG Summary of this function goes here
%   Detailed explanation goes here

numofBlocks = length(C);

rowVec = zeros(numofBlocks+1,1);
colVec = zeros(numofBlocks+1,1);

for block = 1:numofBlocks
   
    [m,n] = size(C{block});
    
    rowVec(block+1) = rowVec(block) + m;
    colVec(block+1) = colVec(block) + n;
end

Res = sparse(rowVec(end), colVec(end));

for block = 1:numofBlocks
   
    Res(rowVec(block)+1:rowVec(block+1), colVec(block)+1:colVec(block+1)) = C{block};
end

end

