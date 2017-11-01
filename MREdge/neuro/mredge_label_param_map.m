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
function mredge_label_param_map(info, prefs, param)

    [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param);
    tpm_image_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
	NIF_EXT = getenv('NIFTI_EXTENSION');
	ABSG_NOISE_THRESH = str2num(getenv('ABSG_NOISE_THRESH'));
    SFWI_NOISE_THRESH = str2num(getenv('SFWI_NOISE_THRESH'));
    
    all_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, ['rwALL', NIF_EXT]));
    if strcmp(param, 'Abs_G') || strcmp(param, 'HELM')
        noise_thresh = ABSG_NOISE_THRESH;
    elseif strcmp(param, 'SFWI')
        noise_thresh = SFWI_NOISE_THRESH;
    else
        noise_thresh = eps;
    end
    label_param_map(STATS_SUB, param, tpm_image_path, all_file, noise_thresh);
    
    %for f = info.driving_frequencies
	%	freq_file = mredge_unzip_if_zip(fullfile(PARAM_SUB, num2str(f), ['rw', num2str(f), NIF_EXT]));
    %    if exist(freq_file, 'file')
    %        label_param_map(STATS_SUB, param, tpm_image_path, freq_file, noise_thresh, f);
    %    end
    %end
       
end

function [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param)

    PARAM_SUB =  mredge_analysis_path(info, prefs, param);
    STATS_SUB = mredge_analysis_path(info, prefs, 'stats');

end

function label_param_map(STATS_SUB, param, tpm_image_path, param_file_path, noise_thresh, f)
 
	param_coreg_vol = load_untouch_nii_eb(param_file_path);
    param_img = param_coreg_vol.img;
    labels_vol = load_untouch_nii_eb(tpm_image_path);
    labels_img = labels_vol.img;
    labels_file = importdata('labels_Neuromorphometrics.xls');
    label_nums = labels_file.data;
    labels = labels_file.textdata(:);
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
        param_values = param_values(param_values < 2046  | param_values > 2050); % nifti converts nan to 2048
        param_values = param_values(param_values > noise_thresh);
        stats(n).label = labels{n}; %#ok<*AGROW>
        stats(n).num_voxels = numel(param_values);
        stats(n).mean = mean(param_values);
        stats(n).median = median(param_values);
        stats(n).std = std(param_values);
        stats(n).min = min(param_values);
        stats(n).max = max(param_values);
    end
    
    if nargin < 6
        label_fileID = fopen(label_stats_path, 'w');
        fprintf(label_fileID, '0 \n');
    else
        label_fileID = fopen(label_stats_path, 'a');
        fprintf(label_fileID, '%.3d \n', f);
    end
    fprintf(label_fileID, '%s\n', 'Label,NumVoxels,Mean,Median,Std,Min,Max');
    wm_cat = [];
    wm_voxnum_cat = [];
    for n = 1:numel(stats)
        if stats(n).num_voxels > 0
            fprintf(label_fileID, '%s,%d,%1.3f,%1.3f,%1.3f,%1.3f,%1.3f\n', stats(n).label, stats(n).num_voxels, stats(n).mean, stats(n).median, stats(n).std, stats(n).min, stats(n).max);
            is_wm = strfind(stats(n).label,WM);
            if any(is_wm) && stats(n).mean > noise_thresh % if this is white matter and not NaN
                % NOTE that thresholding is already accomplished above,
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
        fprintf(label_fileID, '%s,%d,%1.3f,%1.3f%d\n', num2str(f), sum(wm_voxnum_cat), mean(wm_cat), std(wm_cat));
    end
    fclose('all');
    
 
end
        
        

    
