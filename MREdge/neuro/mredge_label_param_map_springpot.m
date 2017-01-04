%% function stats = mredge_label_param_map(info, param)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Applies label volume to parameter map. Returns statistics for each
% labelled anatomical region.
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
function mredge_label_param_map_springpot(info, prefs)

    [SPRINGPOT_SUB, STATS_SUB] = set_dirs(info, prefs);
    tpm_image_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
	NIFTI_EXTENSION = '.nii.gz';
	MU_THRESH = 201;
    
    springpot_files = {'mu', 'mu_weighted', 'alpha', 'alpha_weighted', 'rss', 'rss_weighted'};
    for n = 1:numel(springpot_files)
        param = springpot_files{n};
        param_file_zip = fullfile(SPRINGPOT_SUB,['rw',param, NIFTI_EXTENSION]);
        param_file_unzip = param_file_zip(1:end-3);
        if exist(param_file_zip, 'file')
            gunzip(param_file_zip);
        end
        if strcmp(param, 'mu') == 1 || strcmp(param, 'mu_stable') == 1
            noise_thresh = MU_THRESH;
        else
            noise_thresh = eps;
        end
        label_param_map(STATS_SUB, param, tpm_image_path, param_file_unzip, noise_thresh);

    end

end

function [SPRINGPOT_SUB, STATS_SUB] = set_dirs(info, prefs)

    SPRINGPOT_SUB =  mredge_analysis_path(info, prefs, 'Springpot');
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');

end

function label_param_map(STATS_SUB, param, tpm_image_path, param_file_path, noise_thresh)
 
	param_coreg_vol = load_untouch_nii_eb(param_file_path);
    param_img = param_coreg_vol.img;
    labels_vol = load_untouch_nii_eb(tpm_image_path);
    labels_img = labels_vol.img;
    labels_file = importdata('labels_Neuromorphometrics.xls');
    label_nums = labels_file.data;
    labels = labels_file.textdata(:,2);
    label_stats_path = fullfile(STATS_SUB, ['label_stats_', param, '.csv']);
    num_labels = numel(label_nums);
    WM = 'White Matter';
    wm_sum = 0;
    wm_tally = 0;
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
        stats(n).iqr = iqr(param_values);
        stats(n).min = min(param_values);
        stats(n).max = max(param_values);
    end
    
    label_fileID = fopen(label_stats_path, 'w');
    fprintf(label_fileID, '%s \n', 'Label, Num Voxels, Mean, Median, Std, IQR, Min, Max');
    for n = 1:numel(stats)
        if stats(n).num_voxels > 0
            fprintf(label_fileID, '%s, %d, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f \n', stats(n).label, stats(n).num_voxels, stats(n).mean, stats(n).median, stats(n).std, stats(n).iqr, stats(n).min, stats(n).max);
            is_wm = strfind(stats(n).label,WM);
            if any(is_wm) && stats(n).mean > noise_thresh % if this is white matter and not NaN
                wm_sum = wm_sum + stats(n).mean;
                wm_tally = wm_tally + 1;
            end
        end
    end
    label_fileID = fopen(wm_path, 'a');
    fprintf(label_fileID, '%1.3f \n', wm_sum/wm_tally);
    fclose('all');
    
 
end
        
        

    
