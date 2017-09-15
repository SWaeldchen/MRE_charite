function mredge_phase2double(info)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Make all phase niftis double format, to avoid format conflicts.
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
    phase_path = cell2str(fullfile(info.ds.list(info.ds.enum.phase), subdir));
    phase_vol = load_untouch_nii_eb(phase_path);
    phase_vol.img = double(phase_vol.img);
    phase_vol.hdr.dime.datatype = 64;
    save_untouch_nii(phase_vol, phase_path);
end