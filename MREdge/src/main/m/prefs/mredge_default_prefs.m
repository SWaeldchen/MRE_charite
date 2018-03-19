function default_prefs = mredge_default_prefs
% Sets default preferences for an MREdge preferences structure
%
% INPUTS:
%
%   none
%
% OUTPUTS:
%
%   default preferences struct object
%
% SEE ALSO:
%
%   mredge_prefs
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
% set broad strategies
    default_prefs.distortion_correction = 0;
    default_prefs.motion_correction = 0;
    default_prefs.phase_unwrap = 'laplacian2d';
    default_prefs.temporal_ft = 1;
    default_prefs.denoise_strategy = '3d_soft_visu';
    default_prefs.curl_strategy = 'none';
    default_prefs.component_order = 'zyx';
    default_prefs.inversion_strategy = 'fv';
    default_prefs.directional_filter = 0;
    default_prefs.brain_analysis = 0;
    default_prefs.remove_ipds = 1;
    default_prefs.highpass = 1;
    default_prefs.lowpass = 0;
    default_prefs.gradient_strategy = 'fd';
    default_prefs.analysis_descriptor = '';
    default_prefs.analysis_number = 1;
    default_prefs.freq_indices = [];
    default_prefs.sliding_windows = 0;
% set outputs
    default_prefs.outputs.elastograms = 1;
    default_prefs.outputs.amplitudes = 0;
    default_prefs.outputs.wavefields = 1;
% denoise settings
    default_prefs.denoise_settings.z_level = 2;
    default_prefs.denoise_settings.z_thresh = 1.2;
    default_prefs.denoise_settings.z_hipass_cut = 0.25;
    default_prefs.denoise_settings.xy_level = 3;
    default_prefs.denoise_settings.xy_thresh =  1.2;
    default_prefs.denoise_settings.full3d_thresh = 20;
    default_prefs.denoise_settings.full3d_level = 2;
    default_prefs.denoise_settings.dejitter_norm = 0.5;
    default_prefs.denoise_raw = 0;
    default_prefs.denoise_settings.threshold_gain = 1;
% bandpass settings
    default_prefs.highpass_settings.order = 4;
    default_prefs.highpass_settings.cutoff = 0.03;
    default_prefs.highpass_settings.dimensions = 3;
    default_prefs.lowpass_settings.order = 4;
    default_prefs.lowpass_settings.cutoff = 0.4;
    default_prefs.lowpass_settings.dimensions = 3;
% directional filter setings
    default_prefs.df_settings.dims = 3;
    default_prefs.df_settings.num_filts = 12;
% inversion settings
    default_prefs.inversion_settings.mdev_laplacian_dims = 3;
    default_prefs.inversion_settings.bootstrap = 0;
% moco settings
    default_prefs.moco_method = 'fsl';
% thresholding settings
    default_prefs.anat_mask_thresh_low = 200;
    default_prefs.anat_mask_thresh_high = 1e8; % no high cap
    default_prefs.abs_g_noise_thresh = 500;
    default_prefs.amp_wave_to_noise_thresh = 2;
% compatibility settings for other studies
    default_prefs.compat = [];
% phase unwrapping settings
    default_prefs.phase_unwrapping_settings.phase_range = [];
    default_prefs.phase_unwrapping_settings.force_prelude_3d = 0;
% distortion correction
    default_prefs.dico_method = 'raw';
% file operation settings
    default_prefs.convert_3d_to_4d = 'fsl';
% other settings
    default_prefs.fft_bin = 2;
% set empty dir struct
    default_prefs.ds = [];