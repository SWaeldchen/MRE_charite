function mredge_normalize_phase(info, prefs)
% Normalizes phase data to [0, 2pi) .
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
for subdir = prefs.ds.subdirs_comps_files
    path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.phase), subdir));
    phase_vol = load_untouch_nii_eb(path);
    if ~isempty(prefs.phase_unwrapping_settings.phase_range)
        range_array = prefs.phase_unwrapping_settings.phase_range;
        range = range_array(2) - range_array(1);
        phase_vol.img = ( (phase_vol.img - range_array(1)) / range ) * 2 * pi;
    else
        phase_vol.img = normalizeImage(phase_vol.img)*2*pi;
    end
    save_untouch_nii_eb(phase_vol, path);
end


