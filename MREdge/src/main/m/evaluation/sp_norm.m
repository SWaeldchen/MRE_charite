function [spNorm] = sp_norm(A)
%SPNORM Summary of this function goes here
%   Detailed explanation goes here

spNorm = trace(A'*A);

end

