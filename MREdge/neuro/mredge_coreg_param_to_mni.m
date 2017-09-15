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
    NIF_EXT = getenv('NIFTI_EXTENSION');
    
    y_file = mredge_unzip_if_zip(fullfile(MAG_SUB, ['y_Avg_Magnitude', NIF_EXT]));
    all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ['ALL', NIF_EXT]));

	coreg_param_to_mni(y_file, all_file, info.voxel_spacing*1000); % convert to millimeters

    %for f = info.driving_frequencies
	%	freq_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, num2str(f), [num2str(f), NIF_EXT]));
    %    if exist(freq_file, 'file')
    %        coreg_param_to_mni(y_file, freq_file, info.voxel_spacing*1000);
    %    end
    %end

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
    evalc('spm_jobman(''run'',matlabbatch);');
end
