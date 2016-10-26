function mredge_brain_analysis_stable(info_mag, info_an, prefs)
%% function mredge_brain_analysis(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   coregisters and labels brain results
%
%   If you use this method cite
%
%   [fehlner ref to come]
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

	if nargin == 2
		prefs = info_an;
		info_an = info_mag;
	end
	mredge_avg_mag_to_mni(info_mag, prefs);

    if prefs.outputs.absg == 1
        brain_analysis_stable(info_mag, info_an, prefs, 'Abs_G');
    end
    if prefs.outputs.phi == 1
        brain_analysis_stable(info_mag, info_an, prefs, 'Phi');
    end
    if prefs.outputs.c == 1
        brain_analysis_stable(info, prefs, 'C');
    end
    if prefs.outputs.a == 1
        brain_analysis_stable(info, prefs, 'A');
    end
    if prefs.outputs.amplitude == 1
        brain_analysis_stable(info_mag, info_an, prefs, 'Amp');
    end
end

function brain_analysis_stable(info_mag, info_an, prefs, param)
    
    mredge_coreg_param_to_mni_stable(info_mag, info_an, prefs, param);
    mredge_mni_to_label_space_stable(info_mag, info_an, prefs, param);
    mredge_label_param_map_stable(info_mag, info_an, prefs, param);
    
end

