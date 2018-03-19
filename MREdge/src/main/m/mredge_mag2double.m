function mredge_mag2double(prefs)
% Converts values in magnitude NIfTI objects to double type, to avoid type conflicts.
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
%   mredge_organize_acquisition, mredge_phase2double
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%

for subdir = prefs.ds.subdirs_comps_files
    mag_path = cell2str(fullfile(prefs.ds.list(prefs.ds.enum.magnitude), subdir));
    mag_vol = load_untouch_nii_eb(mag_path);
    mag_vol.img = double(mag_vol.img);
    mag_vol.hdr.dime.datatype = 64;
    save_untouch_nii(mag_vol, mag_path);
end



