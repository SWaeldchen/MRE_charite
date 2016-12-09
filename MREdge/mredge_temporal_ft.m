%% function mredge_temporal_ft(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Temporally Fourier-transforms the complex wave field.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_temporal_ft(info, prefs)

	[PHASE_DIRS, FT_DIRS, SNR_DIRS] =set_dirs(info, prefs);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');

    for d = 1:numel(PHASE_DIRS)
        for f = info.driving_frequencies
            for c = 1:3
                time_series_path = fullfile(PHASE_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
                % create nifti of first volume, to populate with FT data
                time_series_first_path = fullfile(PHASE_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION, '_FT'));
                fslroi_command = ['fsl5.0-fslroi ', time_series_path, ' ', time_series_first_path, ' 0 1'];
                system(fslroi_command);
                time_series_vol = load_untouch_nii(time_series_path);
				% now load the whole time series
                ft_vol = load_untouch_nii(time_series_first_path);
				full_img = time_series_vol.img;
				% call functionality here
				full_img_ft = fft(double(full_img), [],  4);
				ft_vol.img = full_img_ft(:,:,:,2);
				% make nifti adjustments
				ft_vol.hdr.dime.datatype = 32; % change to complex data type
                ft_dir = fullfile(FT_DIRS{d}, num2str(f), num2str(c));
				if ~exist(ft_dir, 'dir')
					mkdir(ft_dir);
				end
				ft_path = fullfile(ft_dir, mredge_filename(f, c, NIFTI_EXTENSION));
				save_untouch_nii(ft_vol, ft_path);
				% delete template volume
                delete(time_series_first_path);
            end
        end
    end

end

function [PHASE_DIRS, FT_DIRS, SNR_DIRS] = set_dirs(info, prefs)
    % use analysis folder for SNR results
	if strcmp(prefs.phase_unwrap, 'gradient') == 1
		PHASE_DIRS = cell(2,1);
		x_set = {'Phase_X', 'FT_X', 'SNR_X'};
		y_set = {'Phase_Y', 'FT_Y', 'SNR_Y'};
		sets = {x_set, y_set};
		PHASE_DIRS = cell(2,1);
		FT_DIRS = cell(2,1);
		SNR_DIRS = cell(2,1);
		for n = 1:2
			PHASE_DIRS{n} = fullfile(info.path, sets{n}{1});
			FT_DIRS{n} = mredge_analysis_path(info, prefs, sets{n}{2});
			SNR_DIRS{n} = mredge_analysis_path(info, prefs, sets{n}{3});
		end
	else
		PHASE_SUB = fullfile(info.path, 'Phase');
		PHASE_DIRS = cell(1,1);
		PHASE_DIRS{1} = PHASE_SUB;
		FT_SUB = mredge_analysis_path(info, prefs, 'FT');
		FT_DIRS = cell(1,1);
		FT_DIRS{1} = FT_SUB;
		SNR_SUB = mredge_analysis_path(info, prefs, 'SNR');
		SNR_DIRS = cell(1,1);
		SNR_DIRS{1} = SNR_SUB;
	end
end


