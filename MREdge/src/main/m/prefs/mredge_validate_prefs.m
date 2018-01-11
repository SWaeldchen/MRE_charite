function prefs = mredge_validate_prefs(prefs)
% Validates some of the more common prefs choices
%
% INPUTS:
%
%   MREdge prefs structure
%
% OUTPUTS:
%
%   Either returns same structure, or throws an error.
%
% NOTE:
%
%   Does not validate every choice, but adds some useful feedback for the
%   most common processing choices.
%
% SEE ALSO:
%
%   mredge_get_valid_preference_options, mredge_prefs, mredge_default_prefs
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
valid_options = mredge_get_valid_preference_options;

if ~ismember_strcheck(prefs.distortion_correction, valid_options.distortion_correction) 
    disp('MREdge ERROR: Invalid distortion correction preference.');
    prefs = [];
    return
end
if ~ismember_strcheck(prefs.motion_correction, valid_options.motion_correction)
    disp('MREdge ERROR: Invalid motion correction preference.');
    prefs = [];
    return
end
if ~ismember_strcheck(prefs.phase_unwrap, valid_options.phase_unwrap)
    disp('MREdge ERROR: Invalid phase unwrapping preference.');
    prefs = [];
    return
end
if ~ismember_strcheck(prefs.denoise_strategy, valid_options.denoise_strategy)
    disp('MREdge ERROR: Invalid denoising preference.');
    prefs = [];
    return
end
if ~ismember_strcheck(prefs.inversion_strategy, valid_options.inversion_strategy)
    disp('MREdge ERROR: Invalid inversion preference.');
    prefs = [];
    return
end
if ~isempty(prefs.freq_indices) && prefs.sliding_windows
    disp('MREdge ERROR: Cannot specify both sliding windows, and a specific frequency set.');
    prefs = [];
    return
end


