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
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    [FT_SUB, FT_R_SUB, FT_I_SUB] = set_dirs(info, prefs);
    % load FT 
    for f = info.driving_frequencies
        for c = 1:3
            ft_vol = load_untouch_nii(mredge_filepath(FT_SUB, f, c));

            ft_r = ft_vol;
            ft_r.img = real(ft_r.img);
            ft_r.hdr.dime.datatype = 64;
            mredge_mkdir(FT_R_SUB, f, c);
            save_untouch_nii(ft_r, mredge_filepath(FT_R_SUB, f, c));

            ft_i = ft_vol;
            ft_i.img = real(ft_r.img);
            ft_i.hdr.dime.datatype = 64;
            mredge_mkdir(FT_I_SUB, f, c);
            save_untouch_nii(ft_i, mredge_filepath(FT_I_SUB, f, c));
        end
    end
end

function [FT_SUB, FT_R_SUB, FT_I_SUB] = set_dirs(info, prefs)
    FT_SUB = mredge_analysis_path(info, prefs, 'FT');
    FT_R_SUB = [FT_SUB, '_R'];
    FT_I_SUB = [FT_SUB, '_I'];
end
