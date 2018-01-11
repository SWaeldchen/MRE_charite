function valid_options = mredge_get_valid_preference_options
% List of some valid preference options for mredge_validate_prefs
%
% INPUTS:
%
%   None
%
% OUTPUTS:
%
%   List of valid preference options
%
% SEE ALSO:
%
%   mredge_validate_prefs, mredge_prefs, mredge_default_prefs
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
valid_options.distortion_correction = {'0', '1'};
valid_options.motion_correction =  {'0','1'};
valid_options.phase_unwrap = {'none', 'laplacian', 'laplacian2d', 'gradient', 'rga', 'prelude'};
valid_options.denoise_strategy = {'none', 'z_xy', '2d_ogs', '2d_soft_visu', '3d_ogs', '3d_soft_visu'};
valid_options.curl_strategy = {'none', 'fd', 'hipass', 'wavelet', 'lsqr', 'dfw'};
valid_options.directional_filter = {'0','1'};
valid_options.inversion_strategy = {'mdev', 'sfwi', 'fv'};

