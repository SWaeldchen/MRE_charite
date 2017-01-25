%% function mni_labels_to_native_space(info, param)

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
function mredge_mni_labels_to_native_space(info, prefs, param)

    [MAG_SUB, PARAM_SUB] = set_dirs(info, prefs, param);
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    
    iy_file = mredge_unzip_if_zip(fullfile(MAG_SUB, ['y_Avg_Magnitude', NIFTI_EXTENSION]));
    all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ['ALL', NIFTI_EXTENSION]));

	mni_labels_to_native_space(iy_file, all_file, info.voxel_spacing*1000); % convert to millimeters

    %for f = info.driving_frequencies
	%	freq_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, num2str(f), [num2str(f), NIFTI_EXTENSION]));
    %    if exist(freq_file, 'file')
    %        mni_labels_to_native_space(y_file, freq_file, info.voxel_spacing*1000);
    %    end
    %end

end

function [MAG_SUB, PARAM_SUB] = set_dirs(info, prefs, param)

    MAG_SUB = mredge_analysis_path(info, prefs, 'Magnitude');
    PARAM_SUB = mredge_analysis_path(info, prefs, param);
    
end

function mni_labels_to_native_space(iy_file, param_file, voxel_spacing)

	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = {iy_file};
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {param_file};
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxel_spacing;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
    spm_jobman('run',matlabbatch);
end
