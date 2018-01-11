function mredge_fd_import(info, prefs)
% Imports continuous-motion MRE data, applying pre-processing of Dittmann et al.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% NOTE:
%
%   Laplacian and RGA methods require the relevant Java .jar . PRELUDE 
%   method requires installation of FSL. PUMA requires installation of PUMA.
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('Dittmann import routine...');
%% create image series
imSer = createImageSeriesFromDicomFiles( info.path );

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
mag_filepath = fullfile(info.path, [num2str(info.magnitude), '.nii']);
phase_vol = load_untouch_nii_eb(phase_filepath);
mag_vol = load_untouch_nii_eb(mag_filepath);
dims = phase_vol.hdr.dime.dim;
dim_swap = [dims(1) dims(3) dims(2) dims(4:end)]; 
% first entry is how many dims there are, so 2 and 3 are swapped
phase_vol.hdr.dime.dim = dim_swap;
mag_vol.hdr.dime.dim = dim_swap;

% now put the imported data in the phase NIfTI
successful_import = 0;
for n = 1:numel(mreCubes)
    if mreCubes(n).SeriesNumber_phase == info.phase && ...
            mreCubes(n).SeriesNumber_magn == info.magnitude
        successful_import = 1;  
        phase_vol.img = angle(mreCubes(n).cube);
        phase_vol.hdr.dime.datatype = 64;
        save_untouch_nii_eb(phase_vol, phase_filepath);
        mag_vol.img = abs(mreCubes(n).cube);
        mag_vol.hdr.dime.datatype = 64;
        save_untouch_nii_eb(mag_vol, mag_filepath);
        data_cube_dir = mredge_mkdir(mredge_analysis_path(info, prefs, 'data_cubes'));
        data_cube = mreCubes(n);
        save(fullfile(data_cube_dir, 'data_cube.mat'), 'data_cube');
        mre_info = mreCubes(n).mreInfo;
        save(fullfile(data_cube_dir, 'mre_info.mat'), 'mre_info');
    end
end
if successful_import
    disp('FD Import Successful');
else
    disp('MREdge ERROR: FD Import Failure.');
end

toc
end
