function mredge_slice_align(info, prefs)
% Dejitters slices using adaptation of Nikolova et al 2001 dejitter algorithm
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% NOTE:
%
%   If you use this algorithm in your work please cite [in revision].
%
% SEE ALSO:
%
%   mredge_remove_ipds
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%

if info.fd_import
    cube_dir = mredge_analysis_path(info, prefs, 'data_cubes');
    mre_info = load(fullfile(cube_dir, 'mre_info.mat'));
    mre_info = mre_info.mre_info;
    ft = mredge_load_FT_as_5d(info, prefs);
    ft_corr = sliceOffsetCorrection(ft, mre_info);
    mredge_save_5d_as_FT(ft_corr, info, prefs);
else
    for subdir = info.ds.subdirs_comps_files
        vol_path = cell2str(fullfile(mredge_analysis_path(info, prefs, 'ft'), subdir));
        vol = load_untouch_nii_eb(vol_path);
        vol.img = dejitter_phase_mask(vol.img, logical(mredge_load_mask(info, prefs)), 0.5, 256);
        save_untouch_nii_eb(vol, vol_path);
    end
end

end