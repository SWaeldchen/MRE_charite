%% function mredge_labels_to_mni_space(info, param)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Transforms the Neuromorphometric labels to MNI space. A prerequisite for
% transforming them in to the brain's native space.
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
function mredge_label_to_mni_space(info, prefs, param)

    [PARAM_SUB] = set_dirs(info, prefs, param);
	NIF_EXT = getenv('NIFTI_EXTENSION');
    tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
    
    all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB,['wALL', NIF_EXT]));
    label_to_mni_space(tpm_path, all_file)
	
	%for f = info.driving_frequencies
	%	freq_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, num2str(f), ['w', num2str(f), NIF_EXT]));
    %    if exist(freq_file, 'file')
    %        label_to_mni_space(tpm_path, freq_file);
    %    end
	%end
    
end

function [PARAM_SUB] = set_dirs(info, prefs, param)

        PARAM_SUB =  mredge_analysis_path(info, prefs, param);
    
end

function label_to_mni_space(tpm_path, unzip_path)
	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.coreg.write.source = {tpm_path};
    matlabbatch{1}.spm.spatial.coreg.write.ref = {unzip_path};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    spm_jobman('run',matlabbatch);
end
    
