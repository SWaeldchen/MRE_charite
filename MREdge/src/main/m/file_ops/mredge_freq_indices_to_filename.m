function filename = mredge_freq_indices_to_filename(info, prefs, freq_indices)
% Converts list of frequency indices to a consistent filename
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%   freq_indices - list of frequency indices
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
if nargin < 3
    if isempty(prefs.inversion_settings.freq_indices)
        freq_indices = info.driving_frequencies;
    else
        freq_indices = prefs.inversion_settings.freq_indices;
    end
end
if numel(freq_indices) == numel(info.driving_frequencies)
    filename = 'ALL.nii';
else
    filename = '';
    nfreqs = numel(freq_indices);
    for n = 1:nfreqs
        filename = [filename, num2str(info.driving_frequencies(freq_indices(n)))]; %#ok<AGROW>
        if n < nfreqs
            filename = [filename, '_']; %#ok<AGROW>
        end
    end
    filename = [filename, getenv('NIFTI_EXTENSION')];
end