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
tpm_image_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');

all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ['r_w_t_', mredge_freq_indices_to_filename(info,prefs,freq_indices)]));
if strcmp(param, 'phi')
    noise_thresh = eps;
else
    noise_thresh = prefs.abs_g_noise_thresh;
end
label_param_map(STATS_SUB, param, tpm_image_path, all_file, noise_thresh, freq_indices);

end

function label_param_map(STATS_SUB, param, tpm_image_path, param_file_path, noise_thresh, freq_indices)
 
	param_coreg_vol = load_untouch_nii_eb(param_file_path);
    param_img = param_coreg_vol.img;
    labels_vol = load_untouch_nii_eb(tpm_image_path);
    labels_img = labels_vol.img;
    labels_file = importdata('labels_Neuromorphometrics.xls');
    label_nums = labels_file.data;
    labels = labels_file.textdata(:,2);
    %freq_label = mredge_freq_indices_to_filename(freq_indices);
    [~, b, ~] = fileparts(param_file_path);
    label_stats_path = fullfile(STATS_SUB, ['brain_analysis_', param, '_', b, '.csv']);
    num_labels = numel(label_nums);
    WM = 'White Matter';
    wm_path = fullfile(STATS_SUB, ['wm_stats_', param, '.csv']);
      
    for n = 1:num_labels
        label_num = label_nums(n);
        label_voxels = labels_img == label_num;
        param_label_voxels = param_img(label_voxels);
        param_values = param_label_voxels(~isnan(param_label_voxels));
        param_values = param_values(param_values > noise_thresh);
        stats(n).label = labels{n}; %#ok<*AGROW>
        stats(n).num_voxels = numel(param_values);
        stats(n).mean = mean(param_values);
        stats(n).median = median(param_values);
        stats(n).std = std(param_values);
        stats(n).min = min(param_values);
        stats(n).max = max(param_values);
    end
 
    if ~exist(label_stats_path, 'file')
        label_fileID = fopen(label_stats_path, 'w');
    else
        label_fileID = fopen(label_stats_path, 'a');
    end
    fprintf(label_fileID, '%s\n', 'Label,NumVoxels,Mean,Median,Std,Min,Max');
    wm_cat = [];
    wm_voxnum_cat = [];
    for n = 1:numel(stats)
        if stats(n).num_voxels > 0
            fprintf(label_fileID, '%s,%d,%1.3f,%1.3f,%1.3f,%1.3f,%1.3f\n', stats(n).label, stats(n).num_voxels, stats(n).mean, stats(n).median, stats(n).std, stats(n).min, stats(n).max);
            is_wm = strfind(stats(n).label,WM);
            if any(is_wm) && stats(n).mean > noise_thresh % if this is white matter and not NaN
                % NOTE: thresholding is already accomplished above,
                % this only ensures removal of all-NaN regions
                wm_cat = cat(1, wm_cat, stats(n).mean);
                wm_voxnum_cat = cat(1, wm_voxnum_cat, stats(n).num_voxels);
            end
        end
    end
    if nargin < 6
        label_fileID = fopen(wm_path, 'w');
        fprintf(label_fileID, '%s,%d,%1.3f,%1.3f,%d\n', 'ALL', sum(wm_voxnum_cat), mean(wm_cat), std(wm_cat));
    else
        label_fileID = fopen(wm_path, 'a');
        fprintf(label_fileID, '%s,%d,%1.3f,%1.3f%d\n', num2str(b), sum(wm_voxnum_cat), mean(wm_cat), std(wm_cat));
    end
    fclose('all');
    
 
end
        
        

    
