function mredge_phase2double(prefs)
% Converts values in phase NIfTI objects to double type, to avoid type conflicts
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
% 
%   mredge_organize_acquisition, mredge_mag2double
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
for subdir = prefs.ds.subdirs_comps_files
    phase_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.phase), subdir));
    phase_vol = load_untouch_nii_eb(phase_path);
    phase_vol.img = double(phase_vol.img);
    phase_vol.hdr.dime.datatype = 64;
    save_untouch_nii(phase_vol, phase_path);
end