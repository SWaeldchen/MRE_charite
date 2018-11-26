function [ result ] = spdiags_own( diagMat, posVec, m,n )
%SPDIAGS_OWN Summary of this function goes here
%   Detailed explanation goes here


[k,d] = size(diagMat);

pad = max(0, -posVec(1));

padMat = zeros(max(k+pad,m),d);


if(m >= n)
    for diag=1:length(posVec)
        prePad = pad + posVec(diag);
        padMat(prePad+1:prePad+k,diag) = diagMat(:,diag); 
    end

else
        padMat(pad+1:pad+k,:) = diagMat; 
end

result = spdiags(padMat, posVec, m, n);


end

