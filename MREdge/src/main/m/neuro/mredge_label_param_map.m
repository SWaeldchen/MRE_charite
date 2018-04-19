function mredge_label_param_map(info, prefs, param, freq_indices)
% Labels paramater map results and produces statistics for brain anatomical regions
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
%   mredge_coreg_param_to_mni, mredge_mni_to_label_space
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
PARAM_SUB =  mredge_analysis_path(info, prefs, param);
STATS_SUB = mredge_analysis_path(info, prefs, 'stats');
%tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');

all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ['r_w_t_', mredge_freq_indices_to_filename(info,prefs,freq_indices)]));
if strcmp(param, 'phi')
    noise_thresh = eps;
else
    noise_thresh = prefs.abs_g_noise_thresh;
end
label_param_map(STATS_SUB, param, all_file, noise_thresh);

end

function label_param_map(STATS_SUB, param, param_file_path, noise_thresh)
 
	param_coreg_vol = load_untouch_nii_eb(param_file_path);
    param_img = param_coreg_vol.img;
    stats = mredge_label_brain(param_img, noise_thresh); 
    [~, b, ~] = fileparts(param_file_path);
    label_stats_path = fullfile(STATS_SUB, ['brain_analysis_', param, '_', b, '.csv']);
    mredge_write_stats_file(stats, label_stats_path);
    
 
end
        
        

    
