%% function mredge_motion_correction(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will perform motion correction on an acquisition.
% Requires SPM 12.
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
function mredge_motion_correction(info, prefs)
    if strcmp(prefs.moco_method,'fsl') == 1
        mredge_motion_correction_fsl(info);
    elseif strcmp(prefs.moco_method,'spm') == 1
        mredge_motion_correction_spm(info, prefs);
    else
        disp('MREdge ERROR: Invalid motion correction method.');
    end
end
