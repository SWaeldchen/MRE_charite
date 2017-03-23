%% function mredge_combine_ft(info, prefs)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Combines real and imaginary parts of complex wave field.
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

function mredge_combine_ft(info, prefs)
    [FT_SUB, FT_R_SUB, FT_I_SUB] = set_dirs(info, prefs);
    
    % load FT 
    for f = info.driving_frequencies
        for c = 1:3
            ft_r_vol = load_untouch_nii(mredge_filepath(FT_R_SUB, f, c));
            ft_i_vol = load_untouch_nii(mredge_filepath(FT_I_SUB, f, c));

            ft_vol = ft_r_vol;
            ft_vol.img = ft_r_vol.img + 1i*ft_i_vol.img;
            ft_vol.hdr.dime.datatype = 32;
            save_untouch_nii(ft_vol, mredge_filepath(FT_SUB, f, c));
            rmdir(mredge_dirpath(FT_R_SUB, f, c), 's');
            rmdir(mredge_dirpath(FT_I_SUB, f, c), 's');
        end
    end
end

function [FT_SUB, FT_R_SUB, FT_I_SUB] = set_dirs(info, prefs)
    FT_SUB = mredge_analysis_path(info, prefs, 'FT');
    FT_R_SUB = [FT_SUB, '_R'];
    FT_I_SUB = [FT_SUB, '_I'];
end