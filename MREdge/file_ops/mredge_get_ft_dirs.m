%% function mredge_get_ft_dirs(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Runs conditional blocks to determine how many wavefield folders there
%   are. If gradient unwrapping and / or directional filtering are used,
%   there are more wavefields to process.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function FT_DIRS = mredge_get_ft_dirs(info, prefs)

	 if strcmp(prefs.phase_unwrap, 'gradient')
        ft_prefixes = {mredge_analysis_path(info, prefs, 'FT_X'), mredge_analysis_path(info, prefs, 'FT_Y')};
    else
        ft_prefixes = {mredge_analysis_path(info, prefs, 'FT')};
    end
    num_prefixes = numel(ft_prefixes);
    for m = 1:num_prefixes
        if prefs.directional_filter == 1
            for n = 1:prefs.df_settings.num_filts
                index = (m-1)*num_prefixes + n;
                FT_DIRS{index} = fullfile(ft_prefixes{m}, ['DIR_',num2str(n)]);  %#ok<AGROW>
            end
        else
            FT_DIRS{1} = ft_prefixes{m};
        end
            
    end

    
end

