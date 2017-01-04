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

function mredge_z_xy_noise(info, prefs)

	[FT_DIRS, STATS_SUB] =set_dirs(info, prefs);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
	z_noise_filepath = fullfile(STATS_SUB, 'noise_est_z.csv');
	xy_noise_filepath = fullfile(STATS_SUB, 'noise_est_xy.csv');
	lap_noise_filepath = fullfile(STATS_SUB, 'noise_est_lap.csv');
	z_noise_ID = fopen(z_noise_filepath, 'w');
	xy_noise_ID = fopen(xy_noise_filepath, 'w');
	lap_noise_ID = fopen(lap_noise_filepath, 'w');
    fprintf(z_noise_ID, 'F.C, Z Noise Est \n');
    fprintf(xy_noise_ID, 'F.C, XY Noise Est \n');
    fprintf(lap_noise_ID, 'F.C, Laplacian Noise Est \n');
    for d = 1:numel(FT_DIRS);
        for f = info.driving_frequencies
            display([num2str(f), ' Hz']);
            z_noise = zeros(3,1);
            xy_noise = zeros(3,1);
            lap_noise = zeros(3,1);
            for c = 1:3
                display(num2str(c));
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
                wavefield_vol = load_untouch_nii_eb(wavefield_path);
				wavefield_img = wavefield_vol.img;
                z_noise(c) = z_noise_est(real(wavefield_img));
                field_mid = middle_square(wavefield_img);
                lap_mid = middle_square(lap(wavefield_img));
				xy_noise(c) = mad_est_3d(wavefield_img) ./ mean(field_mid(:));
                lap_noise(c) = mad_est_3d(lap(wavefield_img)) ./ mean(lap_mid(:));
            end
            z_noise_ID = fopen(z_noise_filepath, 'a');
            xy_noise_ID = fopen(xy_noise_filepath, 'a');
            lap_noise_ID = fopen(lap_noise_filepath, 'a');
            fprintf(z_noise_ID, '%d, %1.3f \n', f, norm(z_noise));
            fprintf(xy_noise_ID, '%d, %1.3f \n', f, norm(xy_noise));
            fprintf(lap_noise_ID, '%d, %1.3f\n', f, norm(lap_noise));
            fclose('all');
        end
    end
end

function [FT_DIRS, STATS_SUB] = set_dirs(info, prefs)
	if strcmp(prefs.phase_unwrap, 'gradient') == 1;
		FT_X = mredge_analysis_path(info, prefs, 'FT X');
		FT_Y = mredge_analysis_path(info, prefs, 'FT Y');
		FT_DIRS = cell(2,1);
		FT_DIRS{1} = FT_X;
		FT_DIRS{2} = FT_Y;
	else
		FT_SUB = mredge_analysis_path(info, prefs, 'FT');
		FT_DIRS = cell(1,1);
		FT_DIRS{1} = FT_SUB;
	end
	STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
end


