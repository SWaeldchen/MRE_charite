%% function mredge_distortion_correction(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will perform distortion correction on the raw complex images of
% an MRE acquisition. info must have valid field_map variable, 
% as well as paired phase and magnitude acquisitions
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
function mredge_distortion_correction_raw(info)
    tic
    disp('MREdge Distortion Correction');
    if ~ info.ds.logical(info.ds.enum.fieldmap)
        disp('MREdge ERROR: No fieldmap directory for this acquisition.');
        return
    end
    fieldmap_dir = fullfile(info.path, info.ds.list(info.ds.enum.fieldmap));
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
    name_4d = fullfile(fieldmap_dir, 'Distortion_Map_4d.nii');
    mredge_3d_to_4d(cell_array, name_4d);

    disp('Prepping...');
	topup_command = ['fsl5.0-topup --imain=', name_4d, ' --datain=', getenv('TOPUP_PARAMS'), ' --config=b02b0.cnf --out=topup_results --fout=topup_field --iout=topup_field_map'];
    system(topup_command);
    TOPUP_RESULTS = fullfile(fieldmap_dir, 'topup_results');

    for subdir = info.ds.subdirs_comps_files
        mredge_pm2ri(info, subdir);
        apply_topup(REAL_SUB, f, c, TOPUP_RESULTS);
        apply_topup(IMAG_SUB, f, c, TOPUP_RESULTS);
        mredge_ri2pm(info, subdir);
    end
    toc
end

function apply_topup(subdir, f, c, TOPUP_RESULTS)

    NIF_EXT = getenv('NIFTI_EXTENSION');
    path = fullfile(subdir, num2str(f), num2str(c), mredge_filename(f, c,  NIF_EXT));
    path_temp = fullfile(subdir, num2str(f), num2str(c), mredge_filename(f, c,  '.nii.gz', 'temp'));
    copyfile(path, path_temp);
	apply_topup_command = ['fsl5.0-applytopup --imain=', path_temp, ' --inindex=1 --datain=', getenv('TOPUP_PARAMS') ' --topup=', TOPUP_RESULTS, ' --method=jac --interp=spline --out=', path];
    system(apply_topup_command);
    mredge_unzip_if_zip(path);
    delete(path_temp);
            
end
