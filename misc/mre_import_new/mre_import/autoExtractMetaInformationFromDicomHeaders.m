function [ dataCubesWithMetaData ] = autoExtractMetaInformationFromDicomHeaders( dataCubes )
%AUTOEXTRACTMETAINFORMATIONFROMDICOMHEADERS Summary of this function goes here
%   Detailed explanation goes here


    if numel(dataCubes)
        for ind=1:numel(dataCubes)
            dataCubesWithMetaData(ind)=autoExtractMetaInformationForOneDataCube(dataCubes(ind));
        end
    else
        dataCubesWithMetaData=dataCubes;
    end
    


    function dataCubeWithMetaData=autoExtractMetaInformationForOneDataCube(dataCube)
        import mre_import.mre_import_helper.*;

        dataCubeWithMetaData=dataCube;
        [ infoMagn ] = getDicomInfoCellArrayFromDataObject( dataCube,'magn' );
        [ info ] = getDicomInfoCellArrayFromDataObject( dataCube,'phase' );
        
        dataCubeWithMetaData.patientName=getDicomHeaderInfo(info{1},'FullPatientName');
        dataCubeWithMetaData.voxel_size_mm=getDicomHeaderInfo(info{1},'VoxelSize');
        dataCubeWithMetaData.StudyTime=info{1}.StudyTime;
        dataCubeWithMetaData.StudyDate=info{1}.StudyDate;
        
        dataCubeWithMetaData.ImageInfo=extractImageMetaInformations(info);
        
        %         dataCubeWithMetaData.ImageOrientationPatient=info{1}.ImageOrientationPatient;
        
        
        dataCubeWithMetaData.SeriesDescription=cell(1,length(info));
        dataCubeWithMetaData.SeriesNumber=zeros(1,length(info));
        dataCubeWithMetaData.SeriesTime=cell(1,length(info));
        
        for index=1:length(info)
            phInfo=info{index};
            dataCubeWithMetaData.SeriesDescription{index}=phInfo.SeriesDescription;
            dataCubeWithMetaData.SeriesNumber(index)=phInfo.SeriesNumber;
            dataCubeWithMetaData.SeriesTime{index}=phInfo.SeriesTime;
            
        end
        
        if isfield(dataCube,'dataType')
            if isequal(dataCube.dataType,'COMPLEX')
                dataCubeWithMetaData.SeriesNumber_phase = dataCubeWithMetaData.SeriesNumber;
                dataCubeWithMetaData=rmfield(dataCubeWithMetaData,'SeriesNumber');
                dataCubeWithMetaData.SeriesNumber_magn=zeros(1,length(infoMagn));
                for index=1:length(infoMagn)
                    magnInfo=infoMagn{index};
                    dataCubeWithMetaData.SeriesNumber_magn(index)=magnInfo.SeriesNumber;
                end
            end
        end
    end

    function imageInfo=extractImageMetaInformations(infos)
        import mre_import.mre_import_helper.*;

        counter=1;
        imageInfo=struct();
        for infoIndex=1:length(infos);
            
            
            dicomHeader=infos{infoIndex};
            
            
            imOrientations=getDicomHeaderInfo(dicomHeader,'AllImagePositions');
            imPositions=getDicomHeaderInfo(dicomHeader,'AllImageOrientations');
            imAcqTimes=getDicomHeaderInfo(dicomHeader,'AllAcquisitionTimes');
            imLocations=getDicomHeaderInfo(dicomHeader,'AllSliceLocations');
            imIceDims=getDicomHeaderInfo(dicomHeader,'AllIceDims');
            
            nImages=size(imOrientations,2);
            for imIndex=1:nImages
                subIndex=counter+imIndex-1;
                imageInfo(subIndex).ImageOrientationPatient=imOrientations(:,imIndex);
                imageInfo(subIndex).ImagePositionPatient=imPositions(:,imIndex);
                imageInfo(subIndex).AcquisitionTime=str2double(imAcqTimes{imIndex});
                imageInfo(subIndex).SliceLocation=imLocations(imIndex);
                imageInfo(subIndex).IceDims=imIceDims(imIndex);
                imageInfo(subIndex).SeriesInstanceUID=dicomHeader.SeriesInstanceUID;
            end
            
            if getDicomHeaderInfo(dicomHeader,'ContainsMreInformation');
                mechCycleTimes_us=getDicomHeaderInfo(dicomHeader,'MechCycleTime');
                timeStepIndices=getDicomHeaderInfo(dicomHeader,'TimeStepIndex');
                dirIndices=getDicomHeaderInfo(dicomHeader,'MegDirIndex');
                freqIndices=getDicomHeaderInfo(dicomHeader,'FreqIndex');
                
                azimuths=getDicomHeaderInfo(dicomHeader,'MegAzimuth');
                polars=getDicomHeaderInfo(dicomHeader,'MegPolar');
                timeCorrectionForSlices_us=getDicomHeaderInfo(dicomHeader,'TimeCorrection');
                
                for imIndex=1:nImages
                    subIndex=counter+imIndex-1;
                    imageInfo(subIndex).mre.mechCycleTime_us=mechCycleTimes_us(imIndex);
                    imageInfo(subIndex).mre.timeStepIndex=timeStepIndices(imIndex);
                    imageInfo(subIndex).mre.dirIndex=dirIndices(imIndex);
                    imageInfo(subIndex).mre.freqIndex=freqIndices(imIndex);
                    azimuth=azimuths(imIndex);
                    polar=polars(imIndex);
                    imageInfo(subIndex).mre.timeCorrectionForSlice_us=...
                        timeCorrectionForSlices_us(imIndex);
                    
                    cubeOrientation=zeros(3);
                    cubeOrientation(:,1)=imageInfo(subIndex).ImagePositionPatient(1:3,1);
                    cubeOrientation(:,1)=cubeOrientation(:,1)./norm(cubeOrientation(:,1));
                    cubeOrientation(:,2)=imageInfo(subIndex).ImagePositionPatient(4:6,1);
                    cubeOrientation(:,2)=cubeOrientation(:,2)./norm(cubeOrientation(:,2));
                    cubeOrientation(:,3)=cross( cubeOrientation(:,1),cubeOrientation(:,2));
                    
                    megVector=cubeOrientation'*...
                       getScannerSystemMatrix()*...
                       getCartesianDirVectorFrom(...
                            azimuth/180*pi,...
                            polar/180*pi);
                    imageInfo(subIndex).mre.megVector=megVector;
                    
                end
                if ~isequal(getDicomHeaderInfo(dicomHeader,'PatientPosition'),'HFS')
                    warning(['Patient positionist not HFS. MEG direction '...
                        'vector will be wrong!']);
                end
            else
                imageInfo(subIndex).mre=[];                
            end
            counter=counter+nImages;
            
            
            
        end
        
    end

    function dir=getCartesianDirVectorFrom(azimuth,polar)
        if ~isequal(size(azimuth),size(polar))
            error('Dimension mismatch');
        end
        dir=zeros(3,length(azimuth));
        dir(1,:)=sin(polar).*cos(azimuth);
        dir(2,:)=sin(polar).*sin(azimuth);
        dir(3,:)=cos(polar);
    end

    function scannerSystemMatrix=getScannerSystemMatrix(patientOrientation)
        scannerSystemMatrix=[1  0   0;...
                             0  -1  0;...
                             0  0   -1];    
    end


end

