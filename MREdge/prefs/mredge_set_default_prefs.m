%% function default_prefs = set_default_prefs;
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
function default_prefs = mredge_set_default_prefs

	%%
	% set broad strategies
		default_prefs.distortion_correction = 0;
		default_prefs.motion_correction = 1;
		default_prefs.aniso_diff = 0;
		default_prefs.gaussian = 0;
		default_prefs.phase_unwrap = 'laplacian2d';
		default_prefs.temporal_ft = 1;
		default_prefs.denoise_strategy = 'z_xy';
		default_prefs.curl_strategy = 'lsqr';
        default_prefs.component_order = 'zyx';
		default_prefs.inversion_strategy = 'helmholtz-wavelet';
        default_prefs.directional_filter = 0;
		default_prefs.super_factor = 0;
        default_prefs.brain_analysis = 0;
	% set outputs
        default_prefs.analysis_descriptor = '';
        default_prefs.analysis_number = 1;
		default_prefs.outputs.absg = 1;
		default_prefs.outputs.phi = 1;
		default_prefs.outputs.c = 0;
		default_prefs.outputs.a = 0;
		default_prefs.outputs.wavefield = 0;
		default_prefs.outputs.amplitude = 1;
        default_prefs.outputs.springpot = 0;
		default_prefs.outputs.rer = 0;
        default_prefs.outputs.snr = 1;
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
		default_prefs.denoise_settings.z_level = 1;
		default_prefs.denoise_settings.z_thresh_factor = 'w2';
		default_prefs.denoise_settings.xy_level = 3;
		default_prefs.denoise_settings.xy_thresh_factor =  0.3;
		default_prefs.denoise_settings.xy_spin = 1;
		default_prefs.denoise_settings.xy_num_spins = 3;
		default_prefs.denoise_settings.full3d_level = 3;
		default_prefs.denoise_settings.full3d_spin = 0;
		default_prefs.denoise_settings.full3d_num_spins = 3;
	% bandpass settings
		default_prefs.highpass_settings.order = 4;
		default_prefs.highpass_settings.cutoff = 0.05;
		default_prefs.highpass_settings.dimensions = 3;
		default_prefs.lowpass_settings.order = 4;
		default_prefs.lowpass_settings.cutoff = 0.3;
		default_prefs.lowpass_settings.dimensions = 3;
		default_prefs.lowpass_settings.cutoff_unit = 'norm';
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
        default_prefs.inversion_settings.laplacian_dims = 3;
    % moco settings
        default_prefs.moco_method = 'spm';
	% thresholding settings
		default_prefs.anat_mask_thresh = 200;
		default_prefs.abs_g_noise_thresh = 500;
		default_prefs.amp_wave_to_noise_thresh = 2;
	% compatibility settings for other studies
		default_prefs.compat = [];
	% phase unwrapping settings
		default_prefs.phase_unwrapping_settings.phase_range = [];
		default_prefs.phase_unwrapping_settings.force_prelude_3d = 0;


        
end