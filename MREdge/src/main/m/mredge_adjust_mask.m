function mredge_average_magnitude(info, prefs)
% Creates a single, averaged t2 magnitude map from an MRE acquisition, the preferred volume to use for co-registration and segmentation.
%
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
%
% OUTPUTS:
%
% none
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
NIF_EXT = getenv('NIFTI_EXTENSION');
avg_sub = mredge_analysis_path(info,prefs, 'magnitude');
avg_path = fullfile(avg_sub, ['avg_magnitude', NIF_EXT]);
avg_vol = load_untouch_nii_eb(avg_path);
mask_vol = avg_vol;
mask_vol.img(mask_vol.img <= prefs.anat_mask_thresh_low) = nan;
mask_vol.img(mask_vol.img >= prefs.anat_mask_thresh_high) = nan;
mask_vol.img(~isnan(mask_vol.img)) = 1;
mask_vol.img(isnan(mask_vol.img)) = 0;
mask_vol.img = double(mask_vol.img);
mask_path = fullfile(avg_sub, 'magnitude_mask', NIF_EXT);
save_untouch_nii_eb(mask_vol, mask_path);
