%% function valid_options = mredge_get_valid_preference_options
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% Method which validates each preferences choice.
%
% INPUTS:
% Preferences structure
%
% OUTPUTS:
% Either returns same structure, or throws an error.

function valid_options = mredge_get_valid_preference_options

	valid_options.distortion_correction = {'0', '1'};
	valid_options.motion_correction =  {'0','1'};
	valid_options.phase_unwrap = {'none', 'laplacian', 'laplacian2d', 'gradient', 'rga'};
	valid_options.temporal_ft =  {'0','1'};
	valid_options.denoise_strategy = {'none', 'z_xy', 'z_3d', '3d', 'lowpass'};
	valid_options.curl_strategy = {'none', 'fd', 'hipass', 'wavelet', 'lsqr', 'dfw'};
    valid_options.directional_filter = {'0','1'};
	valid_options.inversion_strategy = {'helmholtz-fd', 'helmholtz-fd-2d', 'helmholtz-wavelet', 'pg-fd', 'pg_wavelet'};
    
end
