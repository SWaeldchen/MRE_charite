%% function default_prefs = mredge_default_prefs;
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% sets default preferences for an MREdge preferences structure.
%
% INPUTS:
%
% none
%
% OUTPUTS:
%
% default preferences structure
%
function default_prefs = mredge_default_prefs

	%%
	% set broad strategies
		default_prefs.distortion_correction = 0;
		default_prefs.motion_correction = 0;
		default_prefs.aniso_diff = 0;
		default_prefs.gaussian = 0;
		default_prefs.phase_unwrap = 'laplacian2d';
		default_prefs.temporal_ft = 1;
		default_prefs.denoise_strategy = '3d_ogs';
		default_prefs.curl_strategy = 'none';
        default_prefs.component_order = 'zyx';
		default_prefs.inversion_strategy = 'MDEV';
        default_prefs.directional_filter = 0;
		default_prefs.super_factor = 0;
        default_prefs.brain_analysis = 0;
        default_prefs.sliding_windows = 0;
        default_prefs.remove_ipds = 1;
        default_prefs.highpass = 1;
        default_prefs.lowpass = 1;
        default_prefs.gradient_strategy = 'fd';
	% set outputs
        default_prefs.analysis_descriptor = '';
        default_prefs.analysis_number = 1;
		default_prefs.outputs.absg = 1;
		default_prefs.outputs.phi = 0;
		default_prefs.outputs.c = 0;
		default_prefs.outputs.a = 0;
		default_prefs.outputs.wavefield = 0;
		default_prefs.outputs.amplitude = 1;
        default_prefs.outputs.springpot = 0;
		default_prefs.outputs.rer = 0;
        default_prefs.outputs.snr.oss = 1;
        default_prefs.outputs.snr.laplacian = 1;
		default_prefs.outputs.moco = 1;
		default_prefs.outputs.matlab.absg = 0;
		default_prefs.outputs.matlab.phi = 0;
		default_prefs.outputs.matlab.c = 0;
		default_prefs.outputs.matlab.a = 0;
		default_prefs.outputs.matlab.wavefield = 0;
		default_prefs.outputs.matlab.snr = 0;
	% aniso diff settings
		default_prefs.aniso_diff_settings.num_iter = 5;
		default_prefs.aniso_diff_settings.delta_t = (3/44);
		default_prefs.aniso_diff_settings.kappa = 50;
		default_prefs.aniso_diff_settings.option = 1;
	% gaussian settings
		default_prefs.gaussian_settings.sigma = 3;
		default_prefs.gaussian_settings.support = 15;
		default_prefs.gaussian_settings.dimensions = 3;
	% denoise settings
		default_prefs.denoise_settings.z_level = 2;
		default_prefs.denoise_settings.z_thresh = 1.5;
		default_prefs.denoise_settings.z_hipass_cut = 0.25;
		default_prefs.denoise_settings.xy_level = 3;
		default_prefs.denoise_settings.xy_thresh =  1.5;
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
	% wavelet curl settings
		default_prefs.wavelet_curl_settings.level = 1;
		default_prefs.wavelet_curl_settings.thresh_factor = 0.3;
		default_prefs.wavelet_curl_settings.spin = 0;
		default_prefs.wavelet_curl_settings.num_spins = 3;
	% lsq curl settings
		default_prefs.lsq_curl_settings.num_iter = 12;
	% dfw settings
		default_prefs.dfw_settings.dfthresh = 0.1;
		default_prefs.dfw_settings.ndfthresh = 1;
    % directional filter setings
        default_prefs.df_settings.dims = 3;
        default_prefs.df_settings.num_filts = 12;
    % inversion settings
        default_prefs.inversion_settings.mdev_laplacian_dims = 3;
		default_prefs.inversion_settings.freq_indices = [];
        default_prefs.inversion_settings.bootstrap = 0;
    % moco settings
        default_prefs.moco_method = 'fls';
	% thresholding settings
		default_prefs.anat_mask_thresh_low = 200;
		default_prefs.anat_mask_thresh_high = 500;
		default_prefs.abs_g_noise_thresh = 500;
		default_prefs.amp_wave_to_noise_thresh = 2;
	% compatibility settings for other studies
		default_prefs.compat = [];
	% phase unwrapping settings
		default_prefs.phase_unwrapping_settings.phase_range = [];
		default_prefs.phase_unwrapping_settings.force_prelude_3d = 0;
    % distortion correction
		default_prefs.dico_method = 'ft';
    % file operation settings
        default_prefs.convert_3d_to_4d = 'fsl';
        


        
end
