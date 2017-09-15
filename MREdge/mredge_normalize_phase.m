%% function mredge_normalize_phase(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Normalizes the phase of the data to [0, 2pi) .
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_normalize_phase(info, prefs)
    for subdir = info.ds.subdirs_comps
        path = cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir));
        phase_vol = load_untouch_nii_eb(path);
        if ~isempty(prefs.phase_unwrapping_settings.phase_range)
            range_array = prefs.phase_unwrapping_settings.phase_range;
            range = range_array(2) - range_array(1);
            phase_vol.img = ( (phase_vol.img - range_array(1)) / range ) * 2 * pi;
        else
            phase_vol.img = normalizeImage(phase_vol.img)*2*pi;
        end
        save_untouch_nii(phase_vol, path);
    end
end


