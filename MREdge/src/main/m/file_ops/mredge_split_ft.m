function mredge_split_ft(info, prefs)
% Splits the FT images into real and imaginary parts. Needed for FSL FT distortion correction
%
% INPUTS:
%
%   info - MREdge info object
%   prefs - MREdge prefs object
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_combine_ft, mredge_distortion_correction
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
ft = fullfile(mredge_analysis_path(info, prefs, 'FT'));
ft_r = fullfile(mredge_analysis_path(info, prefs, 'FT_R'));
ft_i = fullfile(mredge_analysis_path(info, prefs, 'FT_I'));
for subdir = prefs.ds.subdirs_comps_files
    ft_vol = load_untouch_nii(ft, subdir);
    % real
    ft_r_vol = ft_vol;
    ft_r.img = real(ft_r_vol.img);
    ft_r.hdr.dime.datatype = 64;
    ft_r_dir = fullfile(ft_r, subdir);
    mredge_mkdir(ft_r_dir);
    save_untouch_nii_eb(ft_r, ft_r_dir);
    % imag
    ft_i_vol = ft_vol;
    ft_i.img = imag(ft_i_vol.img);
    ft_i.hdr.dime.datatype = 64;
    ft_i_dir = fullfile(ft_i, subdir);
    mredge_mkdir(ft_i_dir);
    save_untouch_nii_eb(ft_i, ft_i_dir);
end
