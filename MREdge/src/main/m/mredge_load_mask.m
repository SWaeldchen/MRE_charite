function mask = mredge_load_mask(info, prefs)
% Loads the anatomical mask image and returns as a 3D object
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
% prefs - preferences file created with mredge_prefs
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

mask_vol = load_untouch_nii_eb(fullfile(mredge_analysis_path(info, prefs, 'magnitude'), 'magnitude_mask.nii'));
mask = mask_vol.img;