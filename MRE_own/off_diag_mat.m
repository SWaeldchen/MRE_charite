function [A] = off_diag_mat(rows, cols, shift)
%OFF_DIAG_MAT Summary of this function goes here
%   Detailed explanation goes here

A = full(sparse(max(1-shift,1):min(rows,cols-shift),max(1+shift,1):min(cols,rows+shift),1,rows,cols));

end

