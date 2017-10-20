function mredge_remove_ipds(info, prefs)
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Removes interslice phase discontinuities
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

parfor s = 1:numel(info.ds.subdirs_comps_files)
    subdir = info.ds.subdirs_comps_files(s);
    img_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'FT'), subdir));
    img_vol = load_untouch_nii_eb(img_path);
    mask = mredge_load_mask(info, prefs);
    img_vol.img = zden_3D_DWT(img_vol.img, prefs.denoise_settings.z_level, mask);
    save_untouch_nii_eb(img_vol, img_path);
end

