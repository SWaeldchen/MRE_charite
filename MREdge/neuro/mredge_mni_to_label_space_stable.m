%% function mredge_mni_to_label_space_stable(info, param)

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
function mredge_mni_to_label_space_stable(info_mag, info_an, prefs, param)

    [PARAM_SUB] = set_dirs(info_mag, info_an, prefs, param);
	NIFTI_EXTENSION = '.nii.gz';
    tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
  	[stable_filenames, stable_frequencies] = mredge_stable_inversions(info_an, prefs, 0);
	for f = 1:numel(stable_frequencies)
		display([num2str(stable_frequencies(f)), 'Hz']);
		freq_file_zip = fullfile(PARAM_SUB, ['w', stable_filenames{f}]);
		freq_file_unzip = freq_file_zip(1:end-3);
		if exist(freq_file_zip, 'file')
			gunzip(freq_file_zip);
		end		
		mni_to_label_space_stable(tpm_path, freq_file_unzip)
	end
    
end

function [PARAM_SUB] = set_dirs(info_mag, info_an, prefs, param)

        PARAM_SUB =  mredge_analysis_path(info_an, prefs, param);
    
end

function mni_to_label_space_stable(tpm_path, unzip_path)
	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.coreg.write.ref = {tpm_path};
    matlabbatch{1}.spm.spatial.coreg.write.source = {unzip_path};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    spm_jobman('run',matlabbatch);
end
    
