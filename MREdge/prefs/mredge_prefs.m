%% function prefs = mredge_prefs(varargin)
%
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE
%
% This method creates preferences object for MREdge.
% A preferences object is required for MREdge.
% It is recommended to create one preferences object per
% project, enabling easy reproducibility of particular
% parameter decisions.
%
% Calling this method with no arguments sets default preferences.
% The function takes a flexible number of text-value pairs as argument.
% Available choices are:
%
% 'distortion_correction' - Runs the distortion correction routine.
% 	requires your mre_struct to have a non-empty 'fieldmap' field
% 	Valid choices are:
%	0 - off (default)
%	1 - on
%
% 'motion_correction' - Runs the motion correction routine.
% 	Valid choices are:
%	0 - off
%	1 - on (default)
%
% 'aniso_diff' - Runs denoising with anisotropic diffusion
%	prior to phase unwrapping. Usage requires citation of
%		relevant work by Daniel Lopes, ICIST. Settings for this method
%		can be set with the 'aniso_diff_settings' field.
%	Valid choices are:
%	0 - off (default)
%	1 - on
%
% 'gaussian' - Runs denoising with gaussian
%	prior to phase unwrapping. Settings for this method
%	can be set with the 'gaussian_settings' field.
%	Valid choices are:
%	0 - off (default)
%	1 - on
%
% 'phase_unwrap' - Turn on phase unwrapping, and choose algorithm.
% 	Valid choices are:
% 	'none' - No phase unwrapping (default)
% 	'laplacian' - 3D Laplacian based phase unwrapping
% 	'laplacian2d' - 2D Laplacian based phase unwrapping
% 	'gradient' - Unwraps x and y gradients and doubles size of acquisition
%	default is 'none'
%
% 'temporal_ft' - Temporally transforms data from time series into complex
%	wavefield. Turn off if data is pre-processed in some other way
%	which includes a temporal FT.
%	Valid choices are:
%	1 - on (default)
%	0 - off
%
% 'denoise_strategy' - Choose one of several approaches to denoising. Additional
%	parameters can be set in 'denoise_settings'
%	Valid choices are:
%	'none' No denoise (mostly useful for debugging)
%	'z_xy' Denoises Z axis followed by in-plane. Generally a
%		more powerful smoothing approach for low SNR data (default). Settings
%		for this method are in the 'denoise_settings' fields.
%	'z_3d' Denoises z axis followed by a full 3D denoise. Better
%		for high SNR data
%	'3d' Denoises full 3D only. For data with no slice discontinuities
%	'lowpass' Denoises with Butterworth lowpass filter. Mostly useful for
%		debugging and relative comparisons. Settings for this method
%		can be set with the 'lowpass_settings' field
%
% 'curl_strategy' - Method for elimination of low-frequency artifact.
% 	Valid choices are:
%	'none' No curl or hipass (mostly useful for debugging)
%	'fd' Finite differences curl (Matlab builtin method)
%	'hipass' Butterworth high pass filter. Settings for this method
%		can be set with the 'hipass_settings' field
%	'wavelet' Wavelet curl method. Preferences for this method can be set
%		with the 'wavelet_curl_settings' field
%	'lsq' Retention of rotational component from least squares
% 		Helmholtz-Hodge decomposition. Usage requires citation of
%		relevant work by Monika Bahl, IIT Delhi. Settings for this method
%		can be set with the 'lsq_settings' field
%	'dfw' Divergence-free wavelet method. Usage requires citation of
%		relevant work by Frank Ong, UC Berkeley. Settings for this method
%		can be set with the 'dfw_settings' field
%
% 'directional_filter' - Directionally decompose complex wave images.
% 	Valid choices are:
%	0 - off (default)
%	1 - on
%
% 'inversion_strategy' - Method for wave inversion.
%	Valid choices are:
%	'helmholtz_fd' - Helmholtz inversion with compact 3D Laplacian operator
%	'helmholtz_fd_2d' - Helmholtz inversion with 2D Laplacian (mostly for
%		debugging or acquisitions with a lot of patient motion)
%	'helmholtz_wavelet' - Wavelet domain Helmholtz inversion (default)
%	'pg_fd' - Directional filtering and phase gradient inversion. Directional
%		filter settings can be set with 'dirfilt_settings' field
%	'pg_wavelet' - Directional filtering and wavelet domain phase
%			gradient inversion
%
% 'super_factor' - Magnification factor for super-resolution (SR) processing.
% 	Default (enter 0) is mean frequency divided by lowest frequency, squared. Also accepts
% 	any positive real. Entry of 1 skips all SR routines (good for debugging).
%
% 'outputs' - Sets desired outputs. Subfields handle NIfTI and Matlab
% 	outputs. All take 0 (off) or 1 (on):
%		outputs.mag - writes complex modulus magnitude, 3D .nii (default 1)
%		outputs.phi - writes complex modulus phase angle, 3D .nii (default 1)
%		outputs.c - writes wavespeed, 3D .nii (default 0)
%		outputs.a - writes wave penetration, 3D .nii (default 0)
%		outputs.wavefield - writes denoised wavefield, 4D .nii (default 0)
%		outputs.snr - writes wave to noise SNR image, 4D .nii (default 0)
%		outputs.moco - writes motion correction measurements, .xls (default 1)
%		outputs.matlab.mag - returns complex modulus magnitude to MATLAB (default 1)
%		outputs.matlab.phi - returns complex modulus phase angle to MATLAB (default 1)
%		outputs.matlab.c - returns wavespeed to MATLAB (default 0)
%		outputs.matlab.a - returns 	wave penetration to MATLAB (default 0)
%		outputs.matlab.wavefield - returns wavefield to MATLAB (default 1)
% 		outputs.matlab.snr - returns snr image to MATLAB (default 0)
%
% 'aniso_diff_settings' - can set subfields 'num_iter', 'delta_t', 'kappa',
%		and 'option'
%
% 'gaussian_settings' - can set subfields 'sigma', 'support',  and dims (2 or 3)
%
% 'denoise_settings' - can set subfields 'z_level', 'z_thresh_factor',
%	'xy_level','xy_thresh_factor', 'xy_spin', 'xy_num_spins', 'full3d_level',
%	'full3d_thresh_factor','full3d_spin', 'full3d_spin_range'
%
%	for denoise_settings.z_thresh_factor:
%   	values >= 0 will use a constant thresh
%   	'w1' denotes weighting scheme 1: 2 + (1+noise_estimate*2).^2;
%		'w2' denotes weighting scheme 2: 2 + (1+noise_estimate*2);
%
% 'hipass_settings' - can set subfields 'order', 'cutoff' (range 0.1 - 0.99) and
%	'dims' (2 or 3)
%
% 'lowpass_settings' - can set subfields 'order', 'cutoff' (range 0.1 - 0.99) and
%	'dims' (2 or 3)
%
% 'wavelet_curl_settings' - can set subfields 'level', 'thresh_factor',
%	'spin', 'num_spins'
%
% 'lsq_curl_settings' - can set subfield 'num_iter'
%
% 'dfw_settings' - can set subfield 'dfthresh', 'ndfthresh'
function prefs = mredge_prefs(varargin)

prefs = mredge_default_prefs;
for n = 1:2:nargin
    field_is_valid = 1;
    field_break = strfind(varargin{n}, '.');
    if ~isempty(field_break)
        fields = cell(2,1);
        fields{1} = varargin{n}(1:field_break-1);
        fields{2} = varargin{n}( (field_break+1):end );
    else
        fields{1} = varargin{n};
    end
    if isfield(prefs, fields{1})
        if numel(fields) == 1
            prefs.(fields{1}) = varargin{n+1};
        else
            if isfield(prefs.(fields{1}), fields{2})
                prefs.(fields{1}).(fields{2}) = varargin{n+1};
            else
                field_is_valid = 0;
            end
        end
    else
        field_is_valid = 0;
    end
    if field_is_valid == 0
        display(['MREdge ERROR: Invalid preferences field ', varargin{n}]);
        prefs = [];
        return
    end
end
prefs = mredge_validate_prefs(prefs);
end



