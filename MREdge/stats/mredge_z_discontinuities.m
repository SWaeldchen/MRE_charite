%% function mredge_denoise(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Deonise the complex wave field.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_z_discontinuities(info, prefs)

	[FT_DIRS, STATS_SUB] =set_dirs(info, prefs);
	NIF_EXT = '.nii.gz';
	stats_filepath = fullfile(STATS_SUB, 'z_discontinuities.csv')
	if exist(stats_filepath, 'file')
		delete(stats_filepath);
	end
    for d = 1:numel(FT_DIRS);
        for f = info.driving_frequencies
            display([num2str(f), ' Hz']);
            for c = 1:3
                display(num2str(c));
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
                wavefield_vol = load_untouch_nii_eb(wavefield_path);
				wavefield_img = wavefield_vol.img;
                z_noise = z_noise_est(real(wavefield_img));
                fileID = fopen(stats_filepath, 'a');
                fprintf(fileID, '%d, %d, %1.3f \n', f, c, z_noise);
				ft_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
				save_untouch_nii(wavefield_vol, ft_path);
			end
		end
	end
	fclose('all');
end

function [FT_DIRS, STATS_SUB] = set_dirs(info, prefs)
	if strcmp(prefs.phase_unwrap, 'gradient') == 1;
		FT_X = fullfile(info.path, 'FT X');
		FT_Y = fullfile(info.path, 'FT Y');
		FT_DIRS = cell(2,1);
		FT_DIRS{1} = FT_X;
		FT_DIRS{2} = FT_Y;
	else
		FT_SUB = fullfile(info.path, 'FT');
		FT_DIRS = cell(1,1);
		FT_DIRS{1} = FT_SUB;
	end
	STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
end


