function elastograms = mredge_load_elastograms(info, prefs)
% Load elastograms into MATLAB
%
% USAGE:
%
%   elastograms  = mredge_load_elastograms(info, prefs)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   cell array of all elastograms of the inversion type indicated in prefs
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
elastograms = cell(numel(params,1));
for p = 1:numel(params)
    elastogram_path = mredge_analysis_path(info, prefs, params{p});
    elastogram_dir = mredge_dir(elastogram_path);
    for n = 1:numel(elastogram_dir)
        filename = elastogram_dir(n).name;
        if numel(filename) > 4
            if strcmpi(filename((end-3):end), '.nii')
                vol = load_untouch_nii(fullfile(elastogram_path, filename));
                elastograms{p} = vol.img;
            end
        end
    end
end
