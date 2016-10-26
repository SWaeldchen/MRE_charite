%% function mredge_aniso_diff(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls anisotropic diffusion smoothing on real and imaginary MRE acquisition data
%	(prior to phase unwrapping)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_aniso_diff(info, prefs)

	REAL_SUB = fullfile(info.path, 'Real');
	IMAG_SUB = fullfile(info.path, 'Imaginary');

	for f = info.driving_frequencies
		for c = 1:3
			mredge_pm2ri(info, f, c);
			call_aniso_diff(info, prefs, REAL_SUB, f, c);
			call_aniso_diff(info, prefs, IMAG_SUB, f, c);
			mredge_ri2pm(info, f, c);
		end
	end
    

end

function call_aniso_diff(info, subdir, f, c)

	file_list = mredge_split_4d(info, subdir, f, c);
	settings = prefs.aniso_diff_settings;
	for n = 1:numel(file_list)
		volume = load_untouch_nii(file_list{n});
		volume.img = anisodiff3D(volume.img, settings.num_iter, settings.delta_t, settings.kappa, settings.option, info.voxel_spacing);
		save_untouch_nii(file_list{n}, volume);
	end
  
end
