%% function coreg_param_to_mni_stable(info, param)

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
function mredge_coreg_param_to_mni_stable(info_mag, info_an, prefs, param)

	display('Coreg to MNI');
    [MAG_SUB, PARAM_SUB] = set_dirs(info_mag, info_an, prefs, param);
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    
    yfile_zip = fullfile(MAG_SUB, 'y_Avg_Magnitude.nii.gz');
    yfile_unzip = yfile_zip(1:end-3);
    if exist(yfile_zip, 'file')
        gunzip(yfile_zip);
    end

 	[stable_filenames, stable_frequencies] = mredge_stable_inversions(info_an, prefs, 0);
	for f = 1:numel(stable_frequencies)
		disp([num2str(stable_frequencies(f)), 'Hz']);
		freq_file = fullfile(PARAM_SUB, stable_filenames{f});
		coreg_param_to_mni(yfile_unzip, freq_file, info_an.voxel_spacing*1000);
	end
    
    %gzip(yfile_unzip);
    %delete(yfile_unzip);
    %gzip(param_file_unzip);
    %delete(param_file_unzip);

end

function [MAG_SUB, PARAM_SUB] = set_dirs(info_mag, info_an, prefs, param)

    MAG_SUB = mredge_analysis_path(info_an, prefs, 'Magnitude');
    PARAM_SUB = mredge_analysis_path(info_an, prefs, param);
    
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
