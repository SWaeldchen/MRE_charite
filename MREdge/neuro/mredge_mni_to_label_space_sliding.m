%% function mredge_mni_to_label_space_sliding(info, param)

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
function mredge_mni_to_label_space_sliding(info_an, prefs, param)

    [PARAM_SUB] = set_dirs(info_an, prefs, param);
    tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
  	[stable_filenames, stable_frequencies] = mredge_invert_sliding(info_an, prefs, 0);
	for f = 1:numel(stable_frequencies)
		disp(['MNI to Label: ', num2str(stable_frequencies(f)), 'Hz']);
        tic
		freq_file = fullfile(PARAM_SUB, ['w', stable_filenames{f}]);
		mni_to_label_space_sliding(tpm_path, freq_file)
        tic
	end
    
end

function [PARAM_SUB] = set_dirs(info_an, prefs, param)

        PARAM_SUB =  mredge_analysis_path(info_an, prefs, param);
    
end

function mni_to_label_space_sliding(tpm_path, unzip_path)
	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.coreg.write.ref = {tpm_path};
    matlabbatch{1}.spm.spatial.coreg.write.source = {unzip_path};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    evalc('spm_jobman(''run'',matlabbatch);');
end
    