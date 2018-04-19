function amplitudes = mredge_load_amplitudes(info, prefs)
% Load amplitude maps into MATLAB
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   cell array of all amplitude maps
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%   
amplitudes = cell(0);
amp_path = fullfile(mredge_analysis_path(info, prefs, 'amp'));
amp_dir = mredge_dir(amp_path);
tally = 1;
for n = 1:numel(amp_dir)
    filename = amp_dir(n).name;
    if strcmpi(filename((end-3):end), '.nii')
        vol = load_untouch_nii(fullfile(amp_path, filename));
        amplitudes{tally} = vol.img;
        tally = tally + 1;
    end
end

