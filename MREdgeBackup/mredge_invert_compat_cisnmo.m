%% function mredge_invert(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   to come
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_compat_cisnmo(info, prefs)
    phase_data = mredge_load_phase_as_6d(info, prefs);
    [ABSG,PHI,ABSG_orig,PHI_orig,AMP] = evalmmre_cisnmo(phase_data,info.driving_frequencies,info.pixel_spacing);
	for param_name = {'ABSG', 'ABSG_orig', 'PHI', 'PHI_orig', 'AMP'};
    	mredge_save_as_param(info, prefs, param_name, eval(param_name));
	end
end



