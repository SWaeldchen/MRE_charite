function [mreCubes otherMagnitudeCubes otherComplexCubes]=prostateImport(inputPath,outputPath)

import mre_import.*;


%% create image series
display('Creating image series...');
tic;
[imageSeries ] = createImageSeriesFromDicomFiles( inputPath );
toc;

display('FOUND IMAGE SERIES: ');
displayImageSeries(imageSeries);


%% convert image series to data cubes
display('Converting image series to dataCubes...');
tic;
[ dataCubes] = convertAllImageSeriesToDataCubes( imageSeries );
toc;

clear imageSeries;

%% split mosaics
display('Splitting Mosaics...');
tic;
[ dataCubeWithSplitMosaics ] = splitAllMosaicDataCubes( dataCubes );
toc;

clear dataCubes;

%% sort data cubes and convert MRE data to complex cube
display('Creating complex cubes...');
tic;
[ complexCubes otherMagnitudeCubes] = convertMreDataToComplexCubes( dataCubeWithSplitMosaics );
toc;

%% extract meta information from dicom headers
display('Extracting meta information...');
tic;
[complexCubes]=autoExtractMetaInformationFromDicomHeaders(complexCubes);
[otherMagnitudeCubes]=autoExtractMetaInformationFromDicomHeaders(otherMagnitudeCubes);
toc;

display('COMPLEX CUBES: ');
displayComplexMreCubes(complexCubes);

display('OTHER MAGNITUDE CUBES: ');
displayComplexMreCubes(otherMagnitudeCubes);



%% reshape complex cubes and extract MRE information
display('Auto reshape complex cubes and extract MreInfo')
tic;
[ complexCubes ] = autoReshapeAndExtractMreInfoInComplexCubes( complexCubes );
toc;


%% select cubes with complete 3D wave fields
selector=false(size(complexCubes));
for index=1:numel(complexCubes)
    if ~isempty(complexCubes(index).mreInfo)
        mreInfo=complexCubes(index).mreInfo;
        selector(index)=mreInfo.nTimesSteps>=8 && mreInfo.nDirs>=3;
    end
end
mreCubes=complexCubes(selector);
otherComplexCubes=complexCubes(~selector);

%% select concat complex cubes along the frequency dimension
freqDimension=6;
counter=1;
len=3;
for index=1:len:length(mreCubes)
    [ concatMreCubes(counter) ] = concatComplexCubes( ...
        mreCubes(index:(index+len-1)),freqDimension);
    counter=counter+1;
end
mreCubes=concatMreCubes;
clear concatMreCubes;


%% Transform 3D wave fields into image coordinate system

display('Transform 3D wave fields into image coordinate system');
tic;
[ mreCubes ] = transform3DWaveFieldsIntoImageCoordinateSystem( mreCubes );
toc;



%% display import results
display('MRE CUBES: ');
displayComplexMreCubes(mreCubes);

display('OTHER MAGNITUDE CUBES: ');
displayComplexMreCubes(otherMagnitudeCubes);

display('OTHER COMPLEX CUBES: ');
displayComplexMreCubes(otherComplexCubes);

if nargin >1
    display('Saving imported Matlab cubes...');
    save(fullfile(outputPath,'mreCubes.mat'),'mreCubes');
    save(fullfile(outputPath,'otherMagnitudeCubes.mat'),'otherMagnitudeCubes');
    save(fullfile(outputPath,'otherComplexCubes.mat'),'otherComplexCubes');
 
end

end
