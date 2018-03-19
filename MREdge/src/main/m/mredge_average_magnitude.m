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
avg_vol = [];

for subdir = prefs.ds.subdirs_comps_files
    mag_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.magnitude), subdir));
    mag_vol = load_untouch_nii_eb(mag_path);
    if isempty(avg_vol) % use first volume of first image as placeholder
        avg_vol = load_untouch_nii_eb(mag_path);
        avg_vol.img = avg_vol.img(:,:,:,1);
        avg_vol.img = zeros(size(avg_vol.img));
        avg_vol.hdr.dime.dim(1) = 3;
        avg_vol.hdr.dime.dim(5) = 1;
    else
        avg_vol.img = avg_vol.img + sum(mag_vol.img,4);
    end
end

% Changed to aid SPM co-registration 15 Mar 2018
avg_path = fullfile(avg_sub, ['avg_magnitude', NIF_EXT]);
avg_vol.img = avg_vol.img ./ ( numel(info.driving_frequencies) * 3 * info.time_steps);
save_untouch_nii_eb(avg_vol, avg_path);
%avg_vol = make_nii(avg_vol.img ./ ( numel(info.driving_frequencies) * 3 * info.time_steps));
%save_nii(avg_vol, avg_path);
mredge_mkdir(avg_sub);
mask_vol = avg_vol;
mask_vol.img(mask_vol.img <= prefs.anat_mask_thresh_low) = nan;
mask_vol.img(mask_vol.img >= prefs.anat_mask_thresh_high) = nan;
mask_vol.img(~isnan(mask_vol.img)) = 1;
mask_vol.img(isnan(mask_vol.img)) = 0;
mask_vol.img = double(mask_vol.img);
mask_path = fullfile(avg_sub, ['magnitude_mask', NIF_EXT]);
save_untouch_nii(mask_vol, mask_path);
