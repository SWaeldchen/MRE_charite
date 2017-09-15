function mredge_slice_align(info, prefs)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls gaussian smoothing on real and imaginary MRE acquisition data
%	(prior to phase unwrapping)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

for subdir = info.ds.subdirs_comps
    vol_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'FT'), subdir));
    vol = load_untouch_nii_eb(vol_path);
    vol.img = dejitter_phase_mask(vol.img, logical(mredge_load_mask(info, prefs)), 0.5, 256);
    save_untouch_nii_eb(vol, vol_path);
end