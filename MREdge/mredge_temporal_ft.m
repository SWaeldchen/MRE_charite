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

	[PHASE_DIR, FT_DIR, SNR_DIR] =set_dirs(info, prefs);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    FSL_NIFTI_EXTENSION = '.nii.gz';

    for f = info.driving_frequencies
        for c = 1:3
            time_series_path = fullfile(PHASE_DIR, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
            % create nifti of first volume, to populate with FT data
            time_series_first_path = fullfile(PHASE_DIR, num2str(f), num2str(c), mredge_filename(f, c, FSL_NIFTI_EXTENSION, '_FT'));
            fslroi_command = ['fsl5.0-fslroi ', time_series_path, ' ', time_series_first_path, ' 0 1'];
            system(fslroi_command);
            time_series_vol = load_untouch_nii_eb(time_series_path);
            % now load the whole time series
            ft_vol = load_untouch_nii_eb(time_series_first_path);
            full_img = time_series_vol.img;
            % call functionality here
            full_img_ft = fft(align_phase(double(full_img)), [],  4);
            ft_vol.img = full_img_ft(:,:,:,2);
            % make nifti adjustments
            ft_vol.hdr.dime.datatype = 32; % change to complex data type
            ft_dir = fullfile(FT_DIR, num2str(f), num2str(c));
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

function [PHASE_DIR, FT_DIR, SNR_DIR] = set_dirs(info, prefs)
      PHASE_DIR = fullfile(info.path, 'Phase');
      FT_DIR = mredge_analysis_path(info, prefs, 'FT');
      SNR_DIR = mredge_analysis_path(info, prefs, 'SNR');
end


