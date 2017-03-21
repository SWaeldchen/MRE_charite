function [ reshapedComplexCubes ] = autoReshapeAndExtractMreInfoInComplexCubes( complexCubes )
%AUTORESHAPEANDEXTRACTMREINFOINCOMPLEXCUBES Summary of this function goes here
%   Detailed explanation goes here
import mre_import.mre_import_helper.*;
import mre_import.*;

reshapedComplexCubes=complexCubes;


for index=1:numel(complexCubes)
    reshapedComplexCubes(index).mreInfo=[];
    if isempty(complexCubes(index).ImageInfo(1).mre)
        [ sortMatrix isValid ] = autoCreateSortMatrixBasedOnIceDim( complexCubes(index) );
        if isValid
            [ reshapedComplexCubes(index) wasReshaped] = sortAndReshapeMreCube( reshapedComplexCubes(index),sortMatrix );
            if ~wasReshaped
                warning(['Somehow the IceDim information given in complexCube (' num2str(index) ') seems '...
                'inconsistent. Either IceDim information are inconsistent or data set is incomplete.']);
            end
        else
            warning(['Somehow the IceDim information given in complexCube (' num2str(index) ') seems '...
                'inconsistent. Cube is not reshaped.']);
        end
    else
        
        [ sortMatrix isValid ] = autoCreateSortMatrixBasedOnMreImageInfo( complexCubes(index) );
        if isValid
            [ complexCubes(index) wasReshaped] = sortAndReshapeMreCube( complexCubes(index),sortMatrix );
            if ~wasReshaped
                warning(['Somehow the MRE information given in complexCube (' num2str(index) ') seems '...
                'inconsistent. Either MRE information are inconsistent or data set is incomplete.']);
            end
        else
            warning(['Somehow the MRE information given in complexCube (' num2str(index) ') seems '...
                'inconsistent. Cube is not reshaped.']);
        end
        [ reshapedComplexCubes(index) ] = autoExtractMreInfoFromMreDataCube( complexCubes(index) );
%     else
%         warning(['ComplexCube ' num2str(index)  ' does not contain MRE information. No sorting or reshaping is done for this cube!']);
    end
end




end

