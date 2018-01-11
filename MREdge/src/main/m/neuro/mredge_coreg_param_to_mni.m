function mredge_coreg_param_to_mni(info, prefs, param, freq_indices)
% Coregisters a parameter map to MNI space using the deformation map from the averaged magnitude.
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
% none
%
% SEE ALSO:
%
%   mredge_brain_analysis, mredge_avg_mag_to_mni,
%   mredge_mni_to_label_space, mredge_label_parameter_map
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
MAG_SUB = mredge_analysis_path(info, prefs, 'magnitude');
PARAM_SUB = mredge_analysis_path(info, prefs, param);
NIF_EXT = getenv('NIFTI_EXTENSION');

y_file = mredge_unzip_if_zip(fullfile(MAG_SUB, ['y_avg_magnitude', NIF_EXT]));
all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ...
    mredge_freq_indices_to_filename(info,prefs,freq_indices)));

coreg_param_to_mni(y_file, all_file, info.voxel_spacing*1000); % convert to millimeters

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
    % kludge to remove nans
    [a, b, c] = fileparts(param_file);
    w_file = [a, '/', 'w', b, c];
    w_vol = load_untouch_nii_eb(w_file);
    w_vol.img(isnan(w_vol.img)) = 0;
    save_untouch_nii_eb(w_vol, w_file);
end
