function [ transformedComplexCubes ] = transform3DWaveFieldsIntoImageCoordinateSystem( complexCubes )
%TRANSFORM3DWAVEFIELDSINTOIMAGECOORDINATESYSTEM Summary of this function goes here
%   Detailed explanation goes here

import mre_import.*;
import mre_import.mre_import_helper.*;

transformedComplexCubes=complexCubes;


for index=1:numel(complexCubes)
    currCube=complexCubes(index);
    [ sortMatrix ] = getIdentitySortMatrixForComplexCube( currCube );
%     sortMatrix(:,3)=(1:3)*abs(conversionMatrix);
%     si=size(currCube.cube);
    nImages=numel(currCube.ImageInfo);
    if isfield(currCube,'mreInfo')
        if isequal(3,currCube.mreInfo.nDirs)
            for fieldIndex=1:numel(currCube.cube(1,1,1,1,1,:,:))
                for imageIndex=1:nImages
                    megVector=currCube.ImageInfo(imageIndex).mre.megVector;
                    
                    megVector(megVector<-0.9)=-1;
                    megVector(megVector>0.9)=1;
                    megVector(abs(megVector)<0.1)=0;
                    
                    
                    resVector=eye(3)*megVector;
                    [b I]=max(abs(resVector));
                    if b<0.9
                        break;
                    end
                    sortMatrix(imageIndex,3)=I;
                    if resVector(I)<0
                        currCube.cube(:,:,imageIndex)=conj(currCube.cube(:,:,imageIndex));
                        currCube.ImageInfo(imageIndex).mre.megVector=...
                            -currCube.ImageInfo(imageIndex).mre.megVector;
                    end
                end
                
%                 conversionMatrix=currCube.mreInfo.megVectors(:,:,fieldIndex);
%                 
%                 conversionMatrix(conversionMatrix<-0.9)=-1;
%                 conversionMatrix(conversionMatrix>0.9)=1;
%                 conversionMatrix(abs(conversionMatrix)<0.1)=0;
%                 
%                 if ~isAlignedMatrix(conversionMatrix)
%                     continue;
%                 end
%                 
%                 sI=(abs(conversionMatrix)*[1 2 3]')';
                
%                 currCube.mreInfo.timeCorrectionForSlices_us(:,:,:)=currCube.mreInfo.timeCorrectionForSlices_us(:,sI,:);
%                 
%                 
%                 field=currCube.cube(:,:,:,:,:,fieldIndex);
%                 nVecs=prod(si(permIndices(2:end)));
%                 permCube=permute(field,permIndices);
%                 vecsColWise=reshape(permCube,[currCube.mreInfo.nDirs nVecs]);
%                 rotVecs=conversionMatrix*vecsColWise;
%                 rotVecs=reshape(rotVecs,si(permIndices));
%                 currCube.cube(:,:,:,:,:,fieldIndex)=ipermute(rotVecs,permIndices);
%                 currCube.mreInfo.megVectors(:,:,fieldIndex)=eye(3);
                
            end
        else
            warning(['ComplexCube ' num2str(index)  ' does not contain 3 field components. No transformation is done!']);
        end
        
    else
        warning(['ComplexCube ' num2str(index)  ' does not contain MRE information. No transformation is done!']);
    end
    [ currCube ]= sortAndReshapeMreCube( currCube,sortMatrix );
    [ transformedComplexCubes(index) ] = autoExtractMreInfoFromMreDataCube( currCube);
    
end
% 
%     function isAligned=isAlignedMatrix(matrix)
%         isAligned1=0.1>(dot(matrix(:,1),matrix(:,2)));
%         isAligned2=0.1>(dot(matrix(:,1),matrix(:,3)));
%         isAligned3=0.1>(dot(matrix(:,2),matrix(:,3)));
%         isAligned=isAligned1&&isAligned2&&isAligned3;
%     end

end

