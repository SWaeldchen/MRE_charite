function mredge_distortion_correction(info, prefs)
% Correct for distortion in the MRE acquisition using FSL or SPM libraries
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
%   mredge_distortion_correction_raw, mredge_distortion_correction_ft
%
% NOTE:
%
%   This requires fieldmaps in the acquisition, specified in the info
%   struct.
%   At present the FT distortion correction is not recommended.
% 
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
disp('Distortion correction');
tic
if strcmpi(prefs.dico_method,'ft')
    mredge_split_ft(info, prefs);
    mredge_distortion_correction_ft(info, prefs);
    mredge_combine_ft(info, prefs);
elseif strcmpi(prefs.dico_method,'raw')
    mredge_distortion_correction_raw(info);
else
    disp('MREdge ERROR: Invalid distortion correction method.');
end
toc