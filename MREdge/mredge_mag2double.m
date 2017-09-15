function mredge_mag2double(info)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Make all magnitude niftis double, to avoid format conflicts.
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
    mag_path = cell2str(fullfile(info.ds.list(info.ds.enum.magnitude), subdir));
    mag_vol = load_untouch_nii_eb(mag_path);
    mag_vol.img = double(mag_vol.img);
    mag_vol.hdr.dime.datatype = 64;
    save_untouch_nii(mag_vol, mag_path);
end



