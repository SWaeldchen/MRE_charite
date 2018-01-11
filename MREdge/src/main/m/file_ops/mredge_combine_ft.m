function mredge_combine_ft(info, prefs)
% Combines real and imaginary parts of complex wave field. Needed for FSL FT distortion correction.
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
%   mredge_split_ft, mredge_distortion_correction
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
ft = mredge_analysis_path(info, prefs, 'FT');
ft_r = mredge_analysis_path(info, prefs, 'FT_R');
ft_i = mredge_analysis_path(info, prefs, 'FT_I');
for subdir = info.ds.subdirs_comps_files
    ft_r_dir = fullfile(ft_r, subdir);    
    ft_r_vol = load_untouch_nii(ft_r_dir, subdir);
    ft_i_dir = fullfile(ft_i, subdir);    
    ft_i_vol = load_untouch_nii(ft_i_dir, subdir);
    ft_vol = ft_r_vol;
    ft_vol.img = ft_r_vol.img + 1i*ft_i_vol.img;
    ft_vol.hdr.dime.datatype = 32;
    ft_dir = fullfile(ft, subdir);    
    save(ft_vol, ft_dir);
    rmdir(ft_r_dir, 's');
    rmdir(ft_i_dir, 's');
end
rmdir(ft_r, 's');
rmdir(ft_i, 's');

