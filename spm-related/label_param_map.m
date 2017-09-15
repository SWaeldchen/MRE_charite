%%
function label_param_map(path, file, param, noise_thresh)
    
    if nargin < 4
        noise_thresh = 300;
        if nargin < 3
            param = 'absg';
        end
    end

    tpm_image_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
    filepath = fullfile(path, ['rw', file]);
	param_coreg_vol = load_untouch_nii_eb(filepath);
    param_img = param_coreg_vol.img;
    labels_vol = load_untouch_nii_eb(tpm_image_path);
    labels_img = labels_vol.img;
    if strcmpi(file(end-6:end), '.nii.gz')
        filename = file(1:end-8);
    elseif strcmpi(file(end-3:end), '.nii')
        filename = file(1:end-4);
    end
    labels_file = importdata('labels_Neuromorphometrics.xls');
    label_nums = labels_file.data;
    labels = labels_file.textdata(:,2);
    label_stats_path = fullfile(path, [filename,'_label_stats_', param, '.csv']);
    num_labels = numel(label_nums);
    WM = 'White Matter';
    wm_path = fullfile(path, [filename, '_wm_stats_', param, '.csv']);
      
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
        
        

    
