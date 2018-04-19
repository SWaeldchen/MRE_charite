function outputs = mredge_invert_to_end(info, prefs)
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
%
% USAGE:
%
%   calls inversion pipeline specified in prefs on data set specified in info
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   returns a structure containing outputs as specified by prefs

    a = tic;
    prefs.ds = mredge_dir_struct(info, prefs);
    if ~strcmp(prefs.inversion_strategy, 'none')
        mredge_invert_and_stats(info, prefs);
    end
  
    % set outputs
    outputs = [];
    if prefs.outputs.elastograms
        outputs.elastograms = mredge_load_elastograms(info, prefs);
    end
    if prefs.outputs.amplitudes
        outputs.amplitudes = mredge_load_amplitudes(info, prefs);
    end
    if prefs.outputs.wavefields
        outputs.wavefields = mredge_load_FT_as_5d(info, prefs);
    end
end