%% function mredge_distortion_correction(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will perform distortion correction on an acquisition.
% Option for performing this correction on the raw data, or the complex
% wave image, is set in preferences.
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
% prefs - a preference file structure created with mredge_prefs
%
% OUTPUTS:
%
% none
%	
function mredge_distortion_correction(info, prefs)
    if strcmpi(prefs.dico_method,'ft')
        mredge_split_ft(info, prefs);
        mredge_distortion_correction_ft(info, prefs);
        mredge_combine_ft(info, prefs);
    elseif strcmpi(prefs.dico_method,'raw')
        mredge_distortion_correction_raw(info,prefs);
    else
        disp('MREdge ERROR: Invalid distortion correction method.');
    end
end
