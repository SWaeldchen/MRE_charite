function matlab_outputs = mredge_compat_cisnmo(info, prefs)
% Returns results from Fehlner et al 2016 protocol
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

    phase_data = mredge_load_phase_as_6d(info, prefs);
    phase_data = double(phase_data * pi / 4096);
    nifti_placeholder = mredge_get_placeholder_from_phase(info);
    [ABSG,PHI,ABSG_orig,PHI_orig,AMP] = evalmmre_cisnmo(phase_data,info.driving_frequencies,info.voxel_spacing);
    mredge_save_as_param(info, prefs, 'ABSG', ABSG, nifti_placeholder);
    mredge_save_as_param(info, prefs, 'PHI', PHI, nifti_placeholder);
    mredge_save_as_param(info, prefs, 'ÄBSG_orig', ABSG_orig, nifti_placeholder);
    mredge_save_as_param(info, prefs, 'PHI_orig', PHI_orig, nifti_placeholder);
    mredge_save_as_param(info, prefs, 'AMP', AMP, nifti_placeholder);
    matlab_outputs = {ABSG, PHI, ABSG_orig, PHI_orig, AMP};
end



