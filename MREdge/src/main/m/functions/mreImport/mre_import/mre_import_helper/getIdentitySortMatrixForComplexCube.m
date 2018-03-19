function [ sortMatrix ] = getIdentitySortMatrixForComplexCube( complexCube )
%GETIDENTITYSORTMATRIXFORCOMPLEXCUBE Summary of this function goes here
%   Detailed explanation goes here

si=size(complexCube.cube);
si=[si 1 1 1 1 1 1 1];

sortMatrix=zeros(prod(si(3:7)),5);
counter=1;
for sessI=1:si(7)
    for freqI=1:si(6)
        for dI=1:si(5)
            for tI=1:si(4)
                for slI=1:si(3)
                    sortMatrix(counter,:)=[sessI freqI dI tI slI]-1;
                    counter=counter+1;
                end
            end
        end
    end
end



end

