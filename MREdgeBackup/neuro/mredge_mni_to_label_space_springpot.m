%% function mredge_mni_to_label_space(info, param)

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
function mredge_mni_to_label_space_springpot(info, prefs)

    [SPRINGPOT_SUB] = set_dirs(info, prefs);
	NIFTI_EXTENSION = '.nii.gz';
    tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
    
    springpot_files = {'mu', 'mu_weighted', 'alpha', 'alpha_weighted', 'rss', 'rss_weighted'};
    for n = 1:numel(springpot_files)
        param = springpot_files{n};
        param_file_zip = fullfile(SPRINGPOT_SUB,['w',param,'.nii.gz']);
        param_file_unzip = param_file_zip(1:end-3);
        if exist(param_file_zip, 'file')
            gunzip(param_file_zip);
        end
        mni_to_label_space(tpm_path, param_file_unzip)

    end

end

function [PARAM_SUB] = set_dirs(info, prefs)

        PARAM_SUB =  mredge_analysis_path(info, prefs, 'Springpot');
    
end

function mni_to_label_space(tpm_path, unzip_path)
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
    
