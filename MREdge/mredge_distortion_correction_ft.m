%% function mredge_distortion_correction_ft(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will perform distortion correction on FT wave images.
% info must have valid field_map variable, as well as paired
% phase and magnitude acquisitions
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
function mredge_distortion_correction_ft(info, prefs)
    tic
    disp('MREdge Distortion Correction');
    [FIELDMAP_SUB, FT_R_SUB, FT_L_SUB] = set_dirs(info, prefs);
    if ~exist(FIELDMAP_SUB, 'dir')
        disp('MREdge ERROR: No fieldmap directory for this acquisition.');
        return
    end
    cd(FIELDMAP_SUB);
      
    % Select DICOM files, convert and rename
    % Files for Distortion correction (taken from separate 10-seconds scan)
	% should only be one .nii in each Fieldmap series folder
	RL_series = info.fieldmap(1);
	LR_series = info.fieldmap(2);
    RL_nifti_name = dir(fullfile(FIELDMAP_SUB, num2str(RL_series), '*.nii'));
    LR_nifti_name = dir(fullfile(FIELDMAP_SUB, num2str(LR_series), '*.nii'));

    cell_array{1} = fullfile(FIELDMAP_SUB, num2str(RL_series), RL_nifti_name.name);
	cell_array{2} = fullfile(FIELDMAP_SUB, num2str(LR_series), LR_nifti_name.name);
    name_4d = fullfile(FIELDMAP_SUB, 'Distortion_Map_4d.nii');
    mredge_3d_to_4d(cell_array, name_4d);

    disp('Prepping...');
	topup_command = ['fsl5.0-topup --imain=', name_4d, ' --datain=', getenv('TOPUP_PARAMS'), ' --config=b02b0.cnf --out=topup_results --fout=topup_field --iout=topup_field_map'];
    system(topup_command);
    TOPUP_RESULTS = fullfile(FIELDMAP_SUB, 'topup_results');

    for f = info.driving_frequencies
        for c = 1:3
            apply_topup(FT_R_SUB, f, c, TOPUP_RESULTS);
            apply_topup(FT_L_SUB, f, c, TOPUP_RESULTS);
        end
    end
    toc
end

function apply_topup(subdir, f, c, TOPUP_RESULTS)

    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    path = mredge_filepath(subdir, f, c);
    path_temp = fullfile(subdir, num2str(f), num2str(c), mredge_filename(f, c,  '.nii.gz', 'temp'));
    copyfile(path, path_temp);
	apply_topup_command = ['fsl5.0-applytopup --imain=', path_temp, ' --inindex=1 --datain=', getenv('TOPUP_PARAMS') ' --topup=', TOPUP_RESULTS, ' --method=jac --interp=spline --out=', path];
    system(apply_topup_command);
    mredge_unzip_if_zip(path);
    delete(path_temp);
            
end

function [FIELDMAP_SUB, FT_R_SUB, FT_L_SUB] = set_dirs(info, prefs)
    FIELDMAP_SUB = fullfile(info.path, 'Fieldmap');
    FT_R_SUB = mredge_analysis_path(info, prefs, 'FT_R');
    FT_L_SUB = mredge_analysis_path(info, prefs, 'FT_I');
end
