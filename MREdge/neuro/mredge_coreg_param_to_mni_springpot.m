%% function coreg_param_to_mni_springpot(info, param)

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
function mredge_coreg_param_to_mni_springpot(info, prefs)

    [MAG_SUB, SPRINGPOT_SUB] = set_dirs(info, prefs);
    
    yfile_zip = fullfile(MAG_SUB, 'y_Avg_Magnitude.nii.gz');
    yfile_unzip = yfile_zip(1:end-3);
    if exist(yfile_zip, 'file')
        gunzip(yfile_zip);
    end
    
    springpot_files = {'mu', 'mu_weighted', 'alpha', 'alpha_weighted', 'rss', 'rss_weighted'};
    for n = 1:numel(springpot_files)
        param = springpot_files{n};
        param_file_zip = fullfile(SPRINGPOT_SUB,[param,'.nii.gz']);
        param_file_unzip = param_file_zip(1:end-3);
        if exist(param_file_zip, 'file')
            gunzip(param_file_zip);
        end
        coreg_param_to_mni(yfile_unzip, param_file_unzip, info.voxel_spacing*1000);
    end

end

function [MAG_SUB, SPRINGPOT_SUB] = set_dirs(info, prefs)

    MAG_SUB = fullfile(info.path, 'Magnitude/Averaged/');
    SPRINGPOT_SUB = mredge_analysis_path(info, prefs, 'Springpot');
    
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
