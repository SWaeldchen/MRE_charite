%% function coreg_param_to_mni(info, param)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Coregisters a parameter map to MNI space using the deformation map 
% from the averaged magnitude. Requires calling of mredge_average_magnitude
% and mredge_avg_mag_to_mni first.
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
% param - Name of elasticity parameter: 'absg', 'phi', 'c', 'a'
%
% OUTPUTS:
%
% none

%%
function mredge_coreg_param_to_mni(info, prefs, param)

    [MAG_SUB, PARAM_SUB] = set_dirs(info, prefs, param);
    NIFTI_EXTENSION = '.nii.gz';
    
    yfile_zip = fullfile(MAG_SUB, 'y_Avg_Magnitude.nii.gz');
    yfile_unzip = yfile_zip(1:end-3);
    if exist(yfile_zip, 'file')
        gunzip(yfile_zip);
    end
    mdev_file_zip = fullfile(PARAM_SUB,'MDEV.nii.gz');
    mdev_file_unzip = mdev_file_zip(1:end-3);
	if exist(mdev_file_zip, 'file')
    	gunzip(mdev_file_zip);
	end
	coreg_param_to_mni(yfile_unzip, mdev_file_unzip, info.voxel_spacing*1000);

	for f = info.driving_frequencies
		freq_file_zip = fullfile(PARAM_SUB, num2str(f), [num2str(f), NIFTI_EXTENSION]);
		freq_file_unzip = freq_file_zip(1:end-3);
		if exist(freq_file_zip, 'file')
			gunzip(freq_file_zip);
		end
		coreg_param_to_mni(yfile_unzip, freq_file_unzip, info.voxel_spacing*1000);
	end
    
    %gzip(yfile_unzip);
    %delete(yfile_unzip);
    %gzip(param_file_unzip);
    %delete(param_file_unzip);

end

function [MAG_SUB, PARAM_SUB] = set_dirs(info, prefs, param)

    MAG_SUB = mredge_analysis_path(info, prefs, 'Magnitude');
    PARAM_SUB = mredge_analysis_path(info, prefs, param);
    
end

function coreg_param_to_mni(mag_file, param_file, voxel_spacing)

	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = {mag_file};
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {param_file};
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxel_spacing;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
    spm_jobman('run',matlabbatch);
end
