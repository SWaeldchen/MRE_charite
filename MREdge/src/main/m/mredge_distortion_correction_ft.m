function mredge_distortion_correction_ft(info, prefs)
% Correct distortion, applied to the Fourier-transformed wavefield
%
% INPUTS:
%
%   info - an acquisition info structure created with make_acquisition_info
%   prefs - a preference file structure created with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_distortion_correction, mredge_distortion_correction_raw
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('MREdge Distortion Correction');
if ~ info.ds.logical(info.ds.enum.fieldmap)
    disp('MREdge ERROR: No fieldmap directory for this acquisition.');
    return
end
fieldmap_dir = fullfile(info.path, info.ds.list(info.ds.enum.fieldmap));
ftr_dir = mredge_analysis_path(info, prefs, 'FT_R');
fti_dir = mredge_analysis_path(info, prefs, 'FT_I');
cd(fieldmap_dir);

% Select DICOM files, convert and rename
% Files for Distortion correction (taken from separate 10-seconds scan)
% should only be one .nii in each Fieldmap series folder
RL_series = info.fieldmap(1);
LR_series = info.fieldmap(2);
RL_nifti_name = dir(fullfile(fieldmap_dir, num2str(RL_series), '*.nii'));
LR_nifti_name = dir(fullfile(fieldmap_dir, num2str(LR_series), '*.nii'));

cell_array{1} = fullfile(fieldmap_dir, num2str(RL_series), RL_nifti_name.name);
cell_array{2} = fullfile(fieldmap_dir, num2str(LR_series), LR_nifti_name.name);
name_4d = fullfile(fieldmap_dir, 'Distortion_Map_4d.nii.gz');
mredge_3d_to_4d(cell_array, name_4d);

disp('Prepping...');
%topup_command = ['fsl5.0-topup --imain=', name_4d, ' --datain=', getenv('TOPUP_PARAMS'), ' --warpres=16 --subsamp=1 --fwhm=0 --miter=20 --lambda=.000001 --estmov=1 --minmet=0 --out=topup_results --fout=topup_field --iout=topup_field_map'];
topup_command = ['fsl5.0-topup --imain=', name_4d, ' --datain=', getenv('TOPUP_PARAMS'), ' --config=b02b0.cnf --out=topup_results --fout=topup_field --iout=topup_field_map'];
system(topup_command);
TOPUP_RESULTS = fullfile(fieldmap_dir, 'topup_results');
for subdir = info.ds.subdirs_comps_files
    apply_topup(fullfile(ftr_dir, subdir), TOPUP_RESULTS);
    apply_topup(fullfile(fti_dir, subdir), TOPUP_RESULTS);
end
toc
cd(info.path);

end

function apply_topup(subdir, f, c, TOPUP_RESULTS)
    NIF_EXT = getenv('NIFTI_EXTENSION');
    path = mredge_filepath(subdir, f, c);
    path_temp = fullfile(subdir, num2str(f), num2str(c), mredge_filename(f, c,  NIF_EXT, 'temp'));
    copyfile(path, path_temp);
	apply_topup_command = ['fsl5.0-applytopup --imain=', path_temp, ' --inindex=1 --datain=', getenv('TOPUP_PARAMS') ' --topup=', TOPUP_RESULTS, ' --method=jac --interp=spline --out=', path];
    system(apply_topup_command);
    mredge_unzip_if_zip(path);
    delete(path_temp);  
end

