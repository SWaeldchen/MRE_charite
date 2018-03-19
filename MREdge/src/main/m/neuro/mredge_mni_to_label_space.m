function mredge_mni_to_label_space(info, prefs, param, freq_indices)
% Transforms MNI space results to SPM label space
%
% INPUTS:
%
%   info - an acquisition info structure created by make_acquisition_info
%   prefs - MREdge prefs struct
%   param - elasticity parameter
%   freq_indices - indices of driving frequencies
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_brain_analysis, mredge_avg_mag_to_mni,
%   mredge_coreg_param_to_mni, mredge_label_param_map
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
disp('MNI to Label')
PARAM_SUB =  mredge_analysis_path(info, prefs, param);
tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ['w_t_', mredge_freq_indices_to_filename(info,prefs,freq_indices)]));
mni_to_label_space(tpm_path, all_file)
	
end

function mni_to_label_space(tpm_path, unzip_path)
	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.coreg.write.ref = {tpm_path};
    matlabbatch{1}.spm.spatial.coreg.write.source = {unzip_path};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r_';
    spm_jobman('run',matlabbatch');
end
    
