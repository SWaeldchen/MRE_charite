function mredge_invert_and_stats(info, prefs)
% Performs wave inversion and inversion-related statistical measures 
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
% NOTE:
%
%   
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
% run loop across groups for sliding-window multifrequency analysis
tic
disp('Wave Inversion...');
if prefs.sliding_windows == 1
    [~, freq_indices] = sort(info.driving_frequencies, 'ascend');
    nf = numel(freq_indices);
    for n = 1:nf-2
        sliding_group_indices = [freq_indices(n), freq_indices(n+1), freq_indices(n+2)];
        invert_and_stats(info,prefs,sliding_group_indices);
    end
else
    invert_and_stats(info,prefs);
end
toc
end

function invert_and_stats(info, prefs, freq_indices)
    % sort out freq indices
    if nargin < 3
        if isempty(prefs.freq_indices)
            freq_indices = 1:numel(info.driving_frequencies);
        else
            freq_indices = prefs.freq_indices;
        end
    end
    % now process
    mredge_amplitudes(info, prefs, freq_indices);
    if ~strcmp(prefs.inversion_strategy, 'none')
        mredge_invert(info, prefs, freq_indices);
        mredge_masked_median(info, prefs, freq_indices);
        if prefs.brain_analysis
            mredge_brain_analysis(info, prefs, freq_indices);
        end 
    end
end