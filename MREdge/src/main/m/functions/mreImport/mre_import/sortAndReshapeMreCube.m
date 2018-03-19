function [ sortedComplexCube wasReshaped] = sortAndReshapeMreCube( complexCube,sortMatrix )
%AUTOSORTANDRESHAPEMRECUBE Summary of this function goes here
%   Detailed explanation goes here


sortedComplexCube=complexCube;
[B,sortIndices]=sortrows(sortMatrix);




si=size(complexCube.cube);
si=[si(1:2) ones(1,size(sortMatrix,2))];
for index=1:size(sortMatrix,2)
    si(2+index)=numel(unique(sortMatrix(:,end-(index-1))));
end

sortedComplexCube.ImageInfo=complexCube.ImageInfo(sortIndices);
sortedComplexCube.cube=complexCube.cube(:,:,sortIndices);
if prod(si)==numel(sortedComplexCube.cube)
    sortedComplexCube.cube=reshape(sortedComplexCube.cube,si);
    wasReshaped=true;
else
    wasReshaped=false;
    
end

    


end

