function [ splitMosaicData ] = splitMosaics( dataCube )
%SPLITMOSAICS Summary of this function goes here
%   Detailed explanation goes here


import mre_import.mre_import_helper.*;

splitMosaicData=dataCube;

header=getDicomInfoCellArrayFromDataObject(dataCube);
info=header{1};

if ~getDicomHeaderInfo(info,'IsMosaic')
    warning('dataCube is not a Mosaic - splitMosaic did not change anything!');
    return;
end

si=size(dataCube.cube);
nSlices=getDicomHeaderInfo(info,'NumberOfSlices');

dicomSliceDim=[info.Height info.Width];

if ~isequal(si(1:2),dicomSliceDim)
    warning(['splitMosaic did not change anything! Either mosaic is split '...
        'already or argument data are inconsistent.']);
    return;
end

splitMosaicData.cube=extract3DCubeFromMosaic( dataCube.cube ,nSlices );

    function [ resCube ] = extract3DCubeFromMosaic( cube ,numberOfSlices )
        nCols=ceil(sqrt(numberOfSlices));
        nRows=nCols;
        si=size(cube);
        if length(si)<3
            si=[si 1];
        end
        if length(si)<4
            si=[si 1];
        end
        
        cubeDim=[si(1)/nRows si(2)/nCols numberOfSlices si(3:end)];
        trCube=reshape(cube,[si(1:2) 1 prod(si(3:end))]);
        trCubeExtracted=zeros([cubeDim(1:2) nRows*nCols  prod(si(3:end))]);
        for cubeIndex=1:size(trCubeExtracted,4)
            slIndex=1;
            for rowIndex=1:nRows
                for colIndex=1:nCols
                    
                    trCubeExtracted(:,:,slIndex,cubeIndex)=trCube(...
                        (1+(rowIndex-1)*cubeDim(1)):(rowIndex*cubeDim(1)),...
                        (1+(colIndex-1)*cubeDim(2)):(colIndex*cubeDim(2)),...
                        cubeIndex);
                    slIndex=slIndex+1;
                    
                end
            end
        end
        trCubeExtracted=trCubeExtracted(:,:,1:numberOfSlices,:);
        resCube=reshape(trCubeExtracted,cubeDim);
    end


end

