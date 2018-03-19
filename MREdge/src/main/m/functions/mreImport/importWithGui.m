function [mreCubes otherMagnitudeCubes otherComplexCubes]=importWithGui(inputPath,outputPath,concatCubes)

import mre_import.*;

if nargin<1 || isempty(inputPath)
    inputPath = uigetdir(pwd,'INPUT folder');
end

if ~inputPath
    return;
end


if nargin <2 || isempty(outputPath)
    outputPath=uigetdir(pwd,'OUTPUT folder');
end


if nargin <3
    concatCubes=true;
end


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

if concatCubes
    [figHandle complexCubes] = concatCubesUI(complexCubes);
end


%% select cubes with complete 3D wave fields
selector=false(size(complexCubes));
for index=1:numel(complexCubes)
    if ~isempty(complexCubes(index).mreInfo)
        mreInfo=complexCubes(index).mreInfo;
        selector(index)=mreInfo.nTimesSteps>=3 && mreInfo.nDirs==3;
    end
end
mreCubes=complexCubes(selector);
otherComplexCubes=complexCubes(~selector);




%% Transform 3D wave fields into image coordinate system
if ~isempty(mreCubes)
    display('Transform 3D wave fields into image coordinate system');
    tic;
    [ mreCubes ] = transform3DWaveFieldsIntoImageCoordinateSystem( mreCubes );
    toc;
end



%% display import results
display('MRE CUBES: ');
displayComplexMreCubes(mreCubes);

display('OTHER MAGNITUDE CUBES: ');
displayComplexMreCubes(otherMagnitudeCubes);

display('OTHER COMPLEX CUBES: ');
displayComplexMreCubes(otherComplexCubes);


save(fullfile(outputPath,'mreCubes.mat'),'mreCubes');
save(fullfile(outputPath,'otherMagnitudeCubes.mat'),'otherMagnitudeCubes');
save(fullfile(outputPath,'otherComplexCubes.mat'),'otherComplexCubes');
end
