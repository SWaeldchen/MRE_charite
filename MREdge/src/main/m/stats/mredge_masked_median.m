function mredge_masked_median(info, prefs, freq_indices)
% Returns median of masked values for a parameter map
%
% USAGE:
%
%   Using the previously set T2 mask, calculates cortical values for a
%   parameter
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
if strcmpi(prefs.inversion_strategy, 'mdev')
    params = {'absg', 'phi'};
else
    params  = {prefs.inversion_strategy};
end
filename = mredge_freq_indices_to_filename(info, prefs, freq_indices);
for p = 1:numel(params)
    param = params{p};
    param_path = fullfile(mredge_analysis_path(info,  prefs, ...
    param), ... 
    filename);
    param_vol = load_untouch_nii_eb(param_path);
    param_img = param_vol.img;
    mask = double(mredge_load_mask(info,prefs));
    masked = double(simplecrop(mask, size(param_img))).*double(param_img);
    % TODO: add prefs to establish boundary conditions
    % masked = masked(:,:,4:end-3); 
    masked(masked == 0) = nan;
    masked_nonan = masked(~isnan(masked));
    if strcmp(param, 'phi')
        noise_thresh = eps;
    else
        noise_thresh = prefs.abs_g_noise_thresh;
    end
    param_median = median(masked_nonan(masked_nonan > noise_thresh));
    param_var = std(masked_nonan(masked_nonan > noise_thresh)) / param_median;
    fileID = fopen(fullfile(mredge_analysis_path(info, prefs, 'stats'), ...
        'medians.csv'), 'a');
    freq_label = mredge_remove_nifti_extension(filename);
    fprintf(fileID, '%s, %s, %1.4f, %1.4f \n', param, freq_label, param_median, param_var);
    fclose('all');
end