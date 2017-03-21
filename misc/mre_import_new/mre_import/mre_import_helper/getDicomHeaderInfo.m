function ret=getDicomHeaderInfo(header,tag,param1)
%getDicomHeaderInformation Summary of this class goes here
%   Detailed explanation goes here




switch tag
    case 'TR'
        ret=header.RepetitionTime;
    case 'TE'
        ret=header.EchoTime;
    case 'TimeStepIndex'
        ret=getTimeStepIndex(header);
    case 'MegDirIndex'
        ret=getMegDirIndex(header);
    case 'FreqIndex'
        ret=getFreqIndex(header);
    case 'MegAzimuth'
        ret=getMegAzimuth_deg(header);
    case 'MegPolar'
        ret=getMegPolar_deg(header);
    case 'MechCycleTime'
        ret=getMechCycleTime_us(header);
    case 'TimeCorrection'
        ret=getTimeCorrection_us(header);
    case 'InstanceNumber'
        ret=getInstanceNumber(header);
    case 'ImageType'
        ret=getImageType(header);
    case 'SeriesDescription'
        ret=getSeriesDescription(header);
    case 'StudyDescription'
        ret=getStudyDescription(header);
    case 'Filename'
        ret=getFilename(header);
    case 'VoxelSize'
        ret=getVoxelSize_mm(header);
    case 'patientID'
        ret=getPatientID(header);
    case 'studyID'
        ret=getStudyID(header);
    case 'seriesID'
        ret=getSeriesID(header);
    case 'SeriesTime'
        ret=getSeriesTime(header);
    case 'SeriesDate'
        ret=getSeriesDate(header);
    case 'FullPatientName'
        ret=header.PatientName.FamilyName;
    case 'IsPhase'
        ret=isPhase(header);
    case 'IsMagn'
        ret=isMagn(header);
    case 'IsMosaic'
        ret=isMosaic(header);
    case 'NumberOfSlices'
        ret=getNumberOfSlices(header);
    case 'ImagePositionPatientForSlice'
        ret=getImagePositionPatientForSlice(header,param1);
    case 'AllImagePositions'
        ret=getAllImagePositions(header);
    case 'AllImageOrientations'
        ret=getAllImageOrientations(header);
    case 'AllAcquisitionTimes'
        ret=getAllAcquisitionTimes(header);
    case 'AllSliceLocations'
        ret=getAllSliceLocations(header);
    case 'AllIceDims'
        ret=getAllIceDims(header);
    case 'ContainsMreInformation'
        ret=containsMreInformation(header);
    otherwise
        if isfield(header,tag)
            ret=header.(tag);
        else
            error('Unknown tag!');
        end
end

    function values=getValuesFromImageComments(dicomInfo,regExp)
        if isfield(dicomInfo,'ImageComments')
            tag=dicomInfo.ImageComments;
            ret=regexp(tag,regExp,'names');
            values=zeros(size(ret));
            for index=1:numel(values)
                values(index)=str2double(ret{index}.value);
            end
        else
            values=[];
            return;
        end
        
    end

    function repValues=repeatIfMosaic(values,dicomInfo)
        if isMosaic(dicomInfo)
            nSlices=getNumberOfSlices(dicomInfo);
            repValues=repmat(values,nSlices,1);
            repValues=reshape(repValues,[1 numel(repValues)]);
        else
            repValues=values;
        end
    end

    function ts=getTimeStepIndex(dicomInfo)
        ts=getValuesFromImageComments(dicomInfo,'tI\[(?<value>\d+)\]');
        ts=repeatIfMosaic(ts,dicomInfo);
    end

    function dirIndices=getMegDirIndex(dicomInfo)
        dirIndices=getValuesFromImageComments(dicomInfo,'dI\[(?<value>\d+)\]');
        dirIndices=repeatIfMosaic(dirIndices,dicomInfo);
    end

    function freqIndices=getFreqIndex(dicomInfo)
        freqIndices=getValuesFromImageComments(dicomInfo,'fI\[(?<value>\d+)\]');
        freqIndices=repeatIfMosaic(freqIndices,dicomInfo);
    end

    function azimuths=getMegAzimuth_deg(dicomInfo)
        azimuths=getValuesFromImageComments(dicomInfo,'az\[(?<value>\d+)\]');
        azimuths=repeatIfMosaic(azimuths,dicomInfo);
    end

    function polars=getMegPolar_deg(dicomInfo)
        polars=getValuesFromImageComments(dicomInfo,'po\[(?<value>\d+)\]');
        polars=repeatIfMosaic(polars,dicomInfo);
    end


    function mechCycleTime_us=getMechCycleTime_us(dicomInfo)
        mechCycleTime_us=getValuesFromImageComments(dicomInfo,'VP\[(?<value>\d+)\]');
        mechCycleTime_us=repeatIfMosaic(mechCycleTime_us,dicomInfo);
    end

    function timeCorrection_us=getTimeCorrection_us(dicomInfo)
        if isfield(dicomInfo,'ImageComments')
            tag=dicomInfo.ImageComments;
        else
            timeCorrection_us=[];
            return;
        end
        if isMosaic(dicomInfo)
            timeCorrection_us=zeros(4,length(tag));
            ret=regexp(tag,'TC(?<value>\[[;\d]+\])','names');
            for index=1:length(ret)
                if ~isempty(ret{index})
                    %timeCorrection_us(:)=str2double(strtok(ret.value,';'));
                    extract=regexp(ret{index}.value,'(\[|;)(?<value>\d+)','names');
                    timeCorrection_us(:,index)=str2double({extract(:).value});
                end
            end
            nSlices=getNumberOfSlices(dicomInfo);
            timeCorrectionCopy=timeCorrection_us;
            timeCorrection_us=zeros(nSlices,length(tag));
            timeCorrection_us(1:4,:)=timeCorrectionCopy;
            % odd slice numbers
            for index=5:2:nSlices
                timeCorrection_us(index,:)=...
                    timeCorrection_us(index-2,:)+...
                    timeCorrection_us(3,:)-timeCorrection_us(1,:);
            end
            
            % even slice numbers
            for index=6:2:nSlices
                timeCorrection_us(index,:)=...
                    timeCorrection_us(index-2,:)+...
                    timeCorrection_us(4,:)-timeCorrection_us(2,:);
            end
            timeCorrection_us=reshape(timeCorrection_us,[1 numel(timeCorrection_us)]);
        else
            timeCorrection_us=getValuesFromImageComments(dicomInfo,'TC\[(?<value>\d+)\]');
        end
    end

    function instanceNumber=getInstanceNumber(dicomInfo)
        instanceNumber=dicomInfo.InstanceNumber;
    end




    function imageType=getImageType(dicomInfo)
        imageType=dicomInfo.ImageType;
    end




    function seriesDescription=getSeriesDescription(dicomInfo)
        seriesDescription=dicomInfo.SeriesDescription;
    end

    function studyDescription=getStudyDescription(dicomInfo)
        studyDescription=dicomInfo.StudyDescription;
    end

    function fileName=getFilename(dicomInfo)
        fileName=dicomInfo.Filename;
    end

    function voxelSize=getVoxelSize_mm(dicomInfo)
        voxelSize=zeros(1,3);
        voxelSize(1:2)=dicomInfo.PixelSpacing;
        if isfield(dicomInfo,'SpacingBetweenSlices')
            voxelSize(3)=dicomInfo.SpacingBetweenSlices;
        else
            voxelSize(3)=dicomInfo.SliceThickness;
        end
            
    end

    function patientID=getPatientID(dicomInfo)
        patientID=dicomInfo.PatientID;
    end

    function studyID=getStudyID(dicomInfo)
        studyID=dicomInfo.StudyID;
    end

    function seriesID=getSeriesID(dicomInfo)
        seriesID=dicomInfo.SeriesInstanceUID;
    end

    function seriesID=getSeriesTime(dicomInfo)
        seriesID=dicomInfo.SeriesTime;
    end

    function seriesID=getSeriesDate(dicomInfo)
        seriesID=dicomInfo.SeriesDate;
    end


    function fullPatientName=getFullPatientName(dicomInfo)
        fullPatientName=dicomInfo.PatientName.FamilyName;
        
    end

    function imageOrientationPatient=getImageOrientationPatient(dicomInfo)
        imageOrientationPatient=dicomInfo.ImageOrientationPatient;
    end

    function imagePositionPatient=getImagePositionPatient(dicomInfo)
        imagePositionPatient=dicomInfo.ImagePositionPatient;
    end

    function imageDim=getImageDimension(dicomInfo)
        imageDim=[dicomInfo.Height dicomInfo.Width];
    end

    function time=getAllAcquisitionTimes(dicomInfo)
        time=dicomInfo.AcquisitionTime;
        if isMosaic(dicomInfo)
            si=size(time);
            nSlices=getNumberOfSlices(dicomInfo);
            time=reshape(repmat(time,[nSlices 1]),[si(1) nSlices*si(2)]);
        end
    end

    function mosaic=isMosaic(dicomInfo)
        imageType=getImageType(dicomInfo);
        ret=regexp(imageType,'^\w+\\\w+\\\w+\\\w+\\(?<value>\w+)','names');
        if isempty(ret)
            mosaic=false;
            return;
        end
        mosaic=strcmpi('MOSAIC',ret.value);
    end


    function magn=isMagn(dicomInfo)
        imageType=getImageType(dicomInfo);
        ret=regexp(imageType,'^\w+\\\w+\\(?<value>\w+)','names');
        if isempty(ret)
            magn=false;
            return;
        end
        magn=strcmpi('M',ret.value);
    end

    function phase=isPhase(dicomInfo)
        imageType=getImageType(dicomInfo);
        ret=regexp(imageType,'^\w+\\\w+\\(?<value>\w+)','names');
        if isempty(ret)
            phase=false;
            return;
        end
        phase=strcmpi('P',ret.value);
    end



    function CSASeriesHeaderInfo=getCSASeriesHeaderInfo(dicomInfo)
        possibleFieldNames={'Private_0029_1020','CSASeriesHeaderInfo','SpecialCardInfo'};
        fields=isfield(dicomInfo,possibleFieldNames);
        
        CSASeriesHeaderInfo=dicomInfo.(possibleFieldNames{find(fields,1)});
    end

    function CSAImageHeaderInfo=getCSAImageHeaderInfo(dicomInfo)
        possibleFieldNames={'Private_0029_1010','CSAImageHeaderInfo'};
        fields=isfield(dicomInfo,possibleFieldNames);
        
        CSAImageHeaderInfo=dicomInfo.(possibleFieldNames{find(fields,1)});
    end


    function imagePositionPatient=getImagePositionPatientForSlice(dicomInfo,sliceIndex)
        floatPattern='[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?';
        CSASeriesHeaderInfo=getCSASeriesHeaderInfo(dicomInfo);
        
        
        imagePositionPatient=zeros(3,1);
        
        index=1;
        prefix=regexptranslate('escape',['sSliceArray.asSlice[' int2str(sliceIndex-1) '].sPosition.dSag' ]);
        ret=regexp(CSASeriesHeaderInfo,[prefix '\s+=\s+(?<value>' floatPattern ')\s'],'names');
        
        %             if length(ret)>1
        %                 for k=1:length(ret.value)
        %                     display(ret.value(k));
        %                 end
        %             end
        
        if ~isempty(ret)
            imagePositionPatient(index)=str2double(ret(1).value);
        end
        
        index=2;
        prefix=regexptranslate('escape',['sSliceArray.asSlice[' int2str(sliceIndex-1) '].sPosition.dCor' ]);
        ret=regexp(CSASeriesHeaderInfo,[prefix '\s+=\s+(?<value>' floatPattern ')\s'],'names');
        if ~isempty(ret)
            imagePositionPatient(index)=str2double(ret.value);
        end
        
        index=3;
        prefix=regexptranslate('escape',['sSliceArray.asSlice[' int2str(sliceIndex-1) '].sPosition.dTra' ]);
        ret=regexp(CSASeriesHeaderInfo,[prefix '\s+=\s+(?<value>' floatPattern ')\s'],'names');
        if ~isempty(ret)
            imagePositionPatient(index)=str2double(ret.value);
        end
    end

    function numberOfImages=getNumberOfSlices(dicomInfo)
        numberOfImages=0;
        prefix=regexptranslate('escape','sSliceArray.lSize' );
        CSASeriesHeaderInfo=getCSASeriesHeaderInfo(dicomInfo);
        ret=regexp(CSASeriesHeaderInfo,[prefix '\s+=\s+(?<value>[0-9]+)\s'],'names');
        if ~isempty(ret)
            numberOfImages=str2double(ret(1).value);
        end
    end

    function imOrientations=getAllImageOrientations(dicomInfo)
        imOrientations=dicomInfo.ImageOrientationPatient;
        if isMosaic(dicomInfo)
            si=size(imOrientations);
            nSlices=getNumberOfSlices(dicomInfo);
            imOrientations=reshape(repmat(imOrientations,[nSlices 1]),[si(1) nSlices*si(2)]);
        end
    end


    function imPositions=getAllImagePositions(dicomInfo)
        imPositions=dicomInfo.ImagePositionPatient;
        if isMosaic(dicomInfo)
            nRepetitions=size(imPositions,2);
            nSlices=getNumberOfSlices(dicomInfo);
            imPositions=zeros(3,nSlices);
            for slIndex=1:nSlices
                imPositions(:,slIndex)=getImagePositionPatientForSlice(dicomInfo,slIndex);
            end
            imPositions=repmat(imPositions,[1 nRepetitions]);
        end
    end


    function imSliceLocations=getAllSliceLocations(dicomInfo)
        imSliceLocations=dicomInfo.SliceLocation;
        if isMosaic(dicomInfo)
            nSlices=getNumberOfSlices(dicomInfo);
            nRepetitions=size(imSliceLocations,2);
            imSliceLocations=zeros(nSlices,nRepetitions);
            
            sliceOrientation=dicomInfo.ImageOrientationPatient;
            x=sliceOrientation(1:3);
            y=sliceOrientation(4:6);
            z=cross(x,y);
            for repIndex=1:nRepetitions
                for slIndex=1:nSlices
                    imagePosition=getImagePositionPatientForSlice(dicomInfo,slIndex);
                    imSliceLocations(slIndex,repIndex)=dot(imagePosition,z);
                end
            end
        end
    end


    function allIceDims=getAllIceDims(dicomInfo)
        CSAImageHeaderInfo=getCSAImageHeaderInfo(dicomInfo);
        
        dims = {'channel', 'echo', 'phase', 'cset', 'repetition', 'segment', ...
            'partition', 'slice', 'ida'};
        pattern = ['\D(?<' dims{1} '>\d+|X)_(?<' dims{2} '>\d+)_(?<' dims{3} '>\d+)_'...
            '(?<' dims{4} '>\d+)_(?<' dims{5} '>\d+)_(?<' dims{6} '>\d+)_'...
            '(?<' dims{7} '>\d+)_(?<' dims{8} '>\d+)_(?<' dims{9} '>\d+)'];
        allIceDims=regexp(CSAImageHeaderInfo,pattern,'names');
        if iscell(allIceDims)
            allIceDims=[allIceDims{:}];
        end
        for index=1:numel(allIceDims)
            if strcmp(allIceDims(index).channel,'X')
                allIceDims(index).channel='1';
            end
            for index2=1:numel(dims)
                allIceDims(index).(dims{index2})=str2double(allIceDims(index).(dims{index2}));
            end
        end
        
        if isMosaic(dicomInfo)
            nSlices=getNumberOfSlices(dicomInfo);
            allIceDims=repmat(allIceDims,[nSlices 1]);
        end
        
    end

    function containsMre=containsMreInformation(dicomInfo)
        containsMre=false;
        
        if isfield(dicomInfo,'ImageComments')
            tag=dicomInfo.ImageComments;
            if isMosaic(dicomInfo)
                pattern='^MRE:\ fI\[\d+\]dI\[\d+\]az\[\d+\]po\[\d+\]tI\[\d+\]VP\[\d+\]TC\[\d+;\d+;\d+;\d+]$';
            else
                pattern='^MRE:\ fI\[\d+\]dI\[\d+\]az\[\d+\]po\[\d+\]tI\[\d+\]VP\[\d+\]TC\[\d+\]$';
            end
            ret=cell2mat(regexp(tag,pattern));
            if sum(ret(:))<numel(tag)
                containsMre=false;
            else
                containsMre=true;
            end
        end
    end


end

