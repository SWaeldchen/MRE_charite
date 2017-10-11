%% function mredge_split_ft(info, prefs)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Splits the FT images into real and imaginary parts.
% Needed for FSL FT distortion correction.
%
% INPUTS:
%
% info - MREdge info object
% prefs - MREdge prefs object
%
% OUTPUTS:
%
% none

function mredge_split_ft(info, prefs)
    for subdir = info.ds.subdirs_comps_files
        ft_vol = load_untouch_nii(fullfile(mredge_analysis_path(info, prefs, 'FT'), subdir));
        % real
        ft_r = ft_vol;
        ft_r.img = real(ft_r.img);
        ft_r.hdr.dime.datatype = 64;
        ft_r_dir = fullfile(mredge_analysis_path(info, prefs, 'FT_R'), subdir);
        mredge_mkdir(ft_r_dir);
        save_untouch_nii(ft_r, ft_r_dir);
        % imag
        ft_i = ft_vol;
        ft_i.img = real(ft_i.img);
        ft_i.hdr.dime.datatype = 64;
        ft_i_dir = fullfile(mredge_analysis_path(info, prefs, 'FT_I'), subdir);
        mredge_mkdir(ft_i_dir);
        save_untouch_nii(ft_i, ft_i_dir);
    end
end
