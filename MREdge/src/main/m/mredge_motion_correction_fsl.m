function mredge_motion_correction_fsl(info)
% Applies motion correction using FSL.
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
%   mredge_motion_correction, mredge_motion_correction_spm
%
% NOTE:
%
%   Requires a Debian installation of FSL 5.0+
%
% TODO:
%
%   has warnings -- debug
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('MREdge Motion Correction with FSL');
mredge_pm2ri(info);
for subdir = prefs.ds.subdirs_comps_files
    % make a copy, motion correct with copy in, original out
    subdir_temp = [mredge_remove_nifti_extension(subdir), '_temp', NIF_EXT];
    copyfile([prefs.ds.list(prefs.ds.enum.magnitude), subdir], [prefs.ds.list(prefs.ds.enum.magnitude), subdir_temp]);
    mcflirt_command = ['fsl5.0-mcflirt -in ', subdir_temp, ' -out ', subdir,' -smooth 0.5 -mats -stats' ];
    system(mcflirt_command);
    delete(subdir_temp);
    subdir_mat = [mredge_remove_nifti_extension(subdir), '.mat'];
    apply_moco(prefs.ds.list(prefs.ds.enum.real), subdir, subdir_mat, info);
    apply_moco(prefs.ds.list(prefs.ds.enum.imaginary), subdir, subdir_mat, info);
end
mredge_ri2pm(info);
toc
end

function apply_moco(path, path_mag_mat, info)
    path_split_list = mredge_split_4d(path);
    for t = 1:info.time_steps
      	split_image_temp = [fullfile(subdir, path_component), '/vol000', num2str(t-1), '.nii.gz'];
      	split_image_temp_trans = [fullfile(subdir, path_component), '/vol000', num2str(t-1), '_trans.nii.gz'];
      	trans_matrix_temp = [fullfile(path_mag_mat), '/MAT_000', num2str(t-1)];
	  	flirt_command = ['fsl5.0-flirt -in ',split_image_temp,' -ref ',split_image_temp, ' -out ',split_image_temp_trans,' -init ', trans_matrix_temp,' -applyxfm'];
      	system(flirt_command);
      	splitfiles = [splitfiles, ' ', split_image_temp_trans]; %#ok<*AGROW>
    end
	merge_command = ['fsl5.0-fslmerge -t ', path_re, ' ', splitfiles];
    system(merge_command);
end
