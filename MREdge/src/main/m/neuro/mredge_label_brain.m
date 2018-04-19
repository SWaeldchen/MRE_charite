function stats = mredge_label_brain(param_img, noise_thresh)
% Labels an image using SPM parcellation
% 
% INPUTS:
%
%   param_img - coregistered brain image
%
% OUTPUTS:
%
%   struct of labelled summary stats
%
% SEE ALSO:
%
%   mredge_brain_analysis, mredge_avg_mag_to_mni,
%   mredge_coreg_param_to_mni, mredge_mni_to_label_space,
%   mredge_write_stats_file
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
TPM_PATH = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
labels_vol = load_untouch_nii_eb(TPM_PATH);
labels_img = labels_vol.img;
labels_file = importdata('labels_Neuromorphometrics.xls');
label_nums = labels_file.data;
labels = labels_file.textdata(:,2);
num_labels = numel(label_nums);
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