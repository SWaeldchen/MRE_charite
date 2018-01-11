function mredge_motion_correction(info, prefs)
% Performs motion correction on raw MRE acquisitions, using FSL or SPM
%
% INPUTS:
%
%   info - an acquisition info structure created with make_acquisition_info
%   prefs - a preference file structure created with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_motion_correction_fsl, mredge_motion_correction_spm
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
if strcmp(prefs.moco_method,'fsl') == 1
    mredge_motion_correction_fsl(info);
elseif strcmp(prefs.moco_method,'spm') == 1
    mredge_motion_correction_spm(info, prefs);
else
    disp('MREdge ERROR: Invalid motion correction method.');
end