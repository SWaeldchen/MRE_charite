function mredge_brain_analysis(info, prefs, freq_indices)
% Provides co-registration, segmentation and analysis of brain MRE data. Requires SPM12.
%
% USAGE:
%
%   coregisters and labels brain results
%
%   If you use this method cite:
%
%   [paper in revision]
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
% SEE ALSO:
%
%   mredge_avg_mag_to_mni, mredge_coreg_param_to_mni, 
%   mredge_mni_to_label_space, mredge_label_param_map
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%

mredge_transpose_images(info, prefs, freq_indices);
mredge_avg_mag_to_mni(info, prefs);

if strcmpi(prefs.inversion_strategy, 'mdev')
    params = {'absg', 'phi'};
else
    params  = {prefs.inversion_strategy};
end
for p = 1:numel(params)
    param = params{p};
    mredge_coreg_param_to_mni(info, prefs, param, freq_indices);
    mredge_mni_to_label_space(info, prefs, param, freq_indices);
    mredge_label_param_map(info, prefs, param, freq_indices);
end
