function mredge_distortion_correction_raw(info)
% Performs distortion correction on raw MR signal data
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
% NOTE:
%
%   Acquisition must have fieldmap time series, specified in the info struct.
%   Slices must have been acquired with synchronized phases (i.e. not newer
%   continuous-motion protocols).
%
% SEE ALSO:
%
%   mredge_distortion_correction, mredge_distortion_correction_ft
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
disp('MREdge Distortion Correction');
if ~ prefs.ds.logical(prefs.ds.enum.fieldmap)
    disp('MREdge ERROR: No fieldmap directory for this acquisition.');
    return
end
fieldmap_dir = cell2str(prefs.ds.list(prefs.ds.enum.fieldmap));
cd(fieldmap_dir);

% Select DICOM files, convert and rename
% Files for Distortion correction (taken from separate 10-second scans)
% should only be one .nii in each Fieldmap series folder
RL_series = info.fieldmap(1);
LR_series = info.fieldmap(2);
RL_nifti_name = dir(fullfile(fieldmap_dir, [num2str(RL_series), '.nii']));
LR_nifti_name = dir(fullfile(fieldmap_dir, [num2str(LR_series), '.nii']));

cell_array{1} = fullfile(fieldmap_dir, RL_nifti_name.name);
cell_array{2} = fullfile(fieldmap_dir, LR_nifti_name.name);
name_4d = fullfile(fieldmap_dir, 'Distortion_Map_4d.nii');
mredge_3d_to_4d(cell_array, name_4d);

disp('Prepping...');
topup_command = ['fsl5.0-topup --imain=', name_4d, ' --datain=', getenv('TOPUP_PARAMS'), ' --config=b02b0.cnf --out=topup_results --fout=topup_field --iout=topup_field_map'];
system(topup_command);
TOPUP_RESULTS = fullfile(fieldmap_dir, 'topup_results');

mredge_pm2ri(info);
for subdir = prefs.ds.subdirs_comps_files
    apply_topup(cell2str(fullfile(prefs.ds.list(prefs.ds.enum.real), subdir)), TOPUP_RESULTS);
    apply_topup(cell2str(fullfile(prefs.ds.list(prefs.ds.enum.imaginary), subdir)), TOPUP_RESULTS);
end
mredge_ri2pm(info);

end

function apply_topup(path, TOPUP_RESULTS)

    path_temp = [mredge_remove_nifti_extension(path) '_temp.nii.gz'];
    copyfile(path, path_temp);
	apply_topup_command = ['fsl5.0-applytopup --imain=', path_temp, ' --inindex=1 --datain=', getenv('TOPUP_PARAMS') ' --topup=', TOPUP_RESULTS, ' --method=jac --interp=spline --out=', path];
    system(apply_topup_command);
    mredge_unzip_if_zip(path);
    delete(path_temp);
            
end
