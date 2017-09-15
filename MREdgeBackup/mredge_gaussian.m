%% function mredge_gaussian(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls gaussian smoothing on real and imaginary MRE acquisition data
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
			call_gaussian(info, prefs, REAL_SUB, f, c);
			call_gaussian(info, prefs, IMAG_SUB, f, c);
			mredge_ri2pm(info, f, c);
		end
	end
    

end

function call_gaussian(info, subdir, f, c)

	file_list = mredge_split_4d(info, subdir, f, c);
	settings = prefs.gaussian_settings;
	for n = 1:numel(file_list)
		volume = load_untouch_nii_eb(file_list{n});
		if settings.dimensions = 2
			gaussian = fspecial('gaussian', [settings.support settings.support], settings.sigma)
			volume.img = convn(volume.img, gaussian, 'same');
		elseif settings.dimensions = 3
			volume.img = smooth3(volume.img, 'gaussian', settings.support, settings.sigma);
		else
			display('MREdge ERROR: Invalid gaussian dimensions.');
			return;
		end
		save_untouch_nii(file_list{n}, volume);
	end
  
end
