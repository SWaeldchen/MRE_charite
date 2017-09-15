%% function mredge_motion_correction(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will perform motion correction on an acquisition.
% Requires SPM 12.
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
% prefs - a preference file structure created with mredge_prefs
%
% OUTPUTS:
%
% none
%	
function mredge_motion_correction_fsl(info)
    tic
    display('MREdge Motion Correction with FSL');
    cd(info.path);
    MAG_SUB = fullfile(info.path, 'Magnitude');
    REAL_SUB = fullfile(info.path, 'Real');
    IMAG_SUB = fullfile(info.path, 'Imaginary');
    NIFTI_EXTENSION = '.nii.gz';
    
    for f = info.driving_frequencies
        display([num2str(f), 'Hz']);
        for c = 1:3
            
            display(['    ', num2str(c)]);
            mredge_pm2ri(info, f, c);
            
            path_component = fullfile(num2str(f), num2str(c));
            path_end = fullfile(path_component, mredge_filename(f, c,  NIFTI_EXTENSION));
            path_end_temp = fullfile(num2str(f), num2str(c), mredge_filename(f, c,  NIFTI_EXTENSION, 'temp'));
            
            path_mag = fullfile(MAG_SUB, path_end);
            path_mag_temp = fullfile(MAG_SUB, path_end_temp);
            copyfile(path_mag, path_mag_temp);
			mcflirt_command = ['fsl5.0-mcflirt -in ', path_mag_temp, ' -out ', path_mag,' -smooth 0.5 -mats -stats' ];
            system(mcflirt_command);
            path_mag_mat = [path_mag, '.mat'];
                       
            apply_moco(REAL_SUB, path_end, path_component, path_mag_mat, info);
            apply_moco(IMAG_SUB, path_end, path_component, path_mag_mat, info);
            
            mredge_ri2pm(info, f, c);
  
        end
    end
    toc
end

function apply_moco(subdir, path_end, path_component, path_mag_mat, info)
    % a bit to intricate to use mredge_split_4d
    path_re = fullfile(subdir, path_end);
    system(['fsl5.0-fslsplit ',path_re,' ',fullfile(subdir,path_component),'/vol']);
    splitfiles = ' ';
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
