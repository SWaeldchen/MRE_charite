%%
function [asyms, labs, vals] = hemispheric_asymmetry_by_feature(path, file, noise_thresh)
    
    if nargin < 3
        noise_thresh = 300;
    end

    tpm_image_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
    filepath = fullfile(path, ['rw', file]);
	param_coreg_vol = load_untouch_nii_eb(filepath);
    param_img = param_coreg_vol.img;
    labels_vol = load_untouch_nii_eb(tpm_image_path);
    labels_img = labels_vol.img;
    labels_file = importdata('labels_Neuromorphometrics.xls');
    label_nums = labels_file.data;
    labels = labels_file.textdata(:,2);
    num_labels = numel(label_nums);

    featuresR_mean = [];
    %featuresR_nvox = [];
    featuresL_mean = [];
    %featuresL_nvox = [];
    labs = cell(0);
    
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
    
    for n = 1:num_labels-1
        if numel(stats(n).label) > 5
            if strcmpi(stats(n).label(1:5), 'Right') && strcmpi(stats(n+1).label(1:4), 'Left')
                sm = stats(n).mean;
                if ~isempty(sm)
                    featuresR_mean = cat(1, featuresR_mean, sm);
                    %featuresR_nvox = cat(1, featuresR_nvox, stats(n).num_voxels);
                    labs_numel = numel(labs);
                    labs_ = cell(labs_numel+1, 1);
                    labs_(1:numel(labs_)-1) = labs;
                    labs_{end} = stats(n).label(7:end);
                    labs = labs_;
                    featuresL_mean = cat(1, featuresL_mean, stats(n+1).mean);
                    %featuresL_nvox = cat(1, featuresL_nvox, stats(n).num_voxels);
                end
            end
        end
    end
    
    asyms = featuresR_mean ./ featuresL_mean;
    vals = {featuresR_mean, featuresL_mean};

end
 