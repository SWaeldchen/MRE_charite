function [mreCubes otherMagnitudeCubes otherComplexCubes]=standardImport(inputPath,outputPath)


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
% use if you want to save out the data cubes -- takes extra
% time
% save(fullfile(outputPath,'dataCubes.mat'),'dataCubes');

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
        selector(index)=mreInfo.nTimeSteps>=3 && mreInfo.nDirs==3;
    end
end
mreCubes=complexCubes(selector);
otherComplexCubes=complexCubes(~selector);

%% Transform 3D wave fields into image coordinate system

display('Transform 3D wave fields into image coordinate system');
tic;
[ mreCubes ] = transform3DWaveFieldsIntoImageCoordinateSystem( mreCubes );
toc;


%{
%% display import results
display('MRE CUBES: ');
displayComplexMreCubes(mreCubes);

display('OTHER MAGNITUDE CUBES: ');
displayComplexMreCubes(otherMagnitudeCubes);

display('OTHER COMPLEX CUBES: ');
displayComplexMreCubes(otherComplexCubes);

% if nargin >1
    display('Saving imported Matlab cubes...');
    save(fullfile(outputPath,'mreCubes.mat'),'mreCubes');
    save(fullfile(outputPath,'otherMagnitudeCubes.mat'),'otherMagnitudeCubes');
    save(fullfile(outputPath,'otherComplexCubes.mat'),'otherComplexCubes');
 
% end
%}
end
