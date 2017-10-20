function mredge_sort_time_steps(info, prefs)

disp('Sorting time steps');
%% create image series
imSer = createImageSeriesFromDicomFiles( info.path );

for i = 1:numel(imSer)
    dicomHeader=imSer{i}.info;
    seriesNumber=getDicomHeaderInfo(dicomHeader,'SeriesNumber');
    if (seriesNumber == info.phase)
        retainedimSer = imSer(i);
    end
end

imSer = retainedimSer;

%% convert image series to data cubes
dataCubes = convertAllImageSeriesToDataCubes( imSer );

%% split mosaics
dataCubeWithSplitMosaics = splitAllMosaicDataCubes( dataCubes );

%% sort data cubes and convert MRE data to complex cube
tic;
complexCubes = convertMreDataToComplexCubes( dataCubeWithSplitMosaics );
toc;

%% extract meta information from dicom headers
complexCubes=autoExtractMetaInformationFromDicomHeaders(complexCubes);
complexCubes = autoReshapeAndExtractMreInfoInComplexCubes( complexCubes );
mreCubes = transform3DWaveFieldsIntoImageCoordinateSystem( complexCubes );
phase_filepath = fullfile(info.path, [num2str(info.phase), '.nii']);
phase_vol = load_untouch_nii_eb(phase_filepath);
phase_img_resh = resh(phase_vol.img, 3);
phase_vol.img = reshape(phase_img_resh_sort, size(phase_vol.img));
save_untouch_nii(phase_vol, phase_filepath);

dataCubeDir = fullfile(mredge_analysis_path(info, prefs),'dataCubes');
if ~exist(dataCubeDir, 'dir')
    mkdir(dataCubeDir);
end
save(fullfile(dataCubeDir, 'dataCubes.mat'), 'mreCubes');



end
