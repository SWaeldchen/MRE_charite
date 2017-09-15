%% function mredge_ft2double(info,prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Make all ft niftis double format, to avoid format conflicts.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_ft2double(info,prefs)

	[FT_SUB] =set_dirs(info,prefs);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');

    for f = info.driving_frequencies
        for c = 1:3
            ft_path = fullfile(FT_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
            ft_vol = load_untouch_nii_eb(ft_path);
            ft_vol.img = double(ft_vol.img);
            ft_vol.hdr.dime.datatype = 64;
            save_untouch_nii(ft_vol, ft_path);
        end
    end


end

function [FT_SUB] = set_dirs(info,prefs)
    FT_SUB = mredge_analysis_path( info, prefs, 'FT'); 
end


