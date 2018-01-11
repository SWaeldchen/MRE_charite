function mredge_remove_ipds(info, prefs)
% Removes interslice phase discontinuities
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
%   If you use this algorithm in your work please cite [in revision].
%
% SEE ALSO:
%
%   mredge_slice_align
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('IPD Removal');
parfor s = 1:numel(info.ds.subdirs_comps_files)
    subdir = info.ds.subdirs_comps_files(s); %#ok<PFBNS>
    img_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir));
    img_vol = load_untouch_nii_eb(img_path);
    mask = mredge_load_mask(info, prefs);
    img_vol.img = zden_3D_DWT(img_vol.img, prefs.denoise_settings.z_level, mask);
    save_untouch_nii_eb(img_vol, img_path);
end
toc
