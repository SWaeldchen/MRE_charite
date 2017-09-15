%% function prefs = validate_prefs(prefs)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Method which validates each preferences choice. Only strategy choices are 
% validated; users are on their own with minor parameters.
%
% INPUTS:
%
% Preferences structure
%
% OUTPUTS:
%
% Either returns same structure, or throws an error.

function prefs = mredge_validate_prefs(prefs)

	valid_options = mredge_get_valid_preference_options;

	if ~ismember_strcheck(prefs.distortion_correction, valid_options.distortion_correction) 
		display('MREdge ERROR: Invalid distortion correction preference.');
		prefs = [];
        return
	end
	if ~ismember_strcheck(prefs.motion_correction, valid_options.motion_correction)
		display('MREdge ERROR: Invalid motion correction preference.');
		prefs = [];
        return
	end
	if ~ismember_strcheck(prefs.temporal_ft, valid_options.temporal_ft)
		display('MREdge ERROR: Invalid phase unwrapping preference.');
		prefs = [];
        return
	end
	if ~ismember_strcheck(prefs.phase_unwrap, valid_options.phase_unwrap)
		display('MREdge ERROR: Invalid phase unwrapping preference.');
		prefs = [];
        return
	end
	if ~ismember_strcheck(prefs.denoise_strategy, valid_options.denoise_strategy)
		display('MREdge ERROR: Invalid denoising preference.');
		prefs = [];
        return
	end
	if ~ismember_strcheck(prefs.curl_strategy, valid_options.curl_strategy)
		display('MREdge ERROR: Invalid curl preference.');
		prefs = [];
        return
	end
	if ~ismember_strcheck(prefs.inversion_strategy, valid_options.inversion_strategy)
		display('MREdge ERROR: Invalid inversion preference.');
		prefs = [];
        return
	end

end


