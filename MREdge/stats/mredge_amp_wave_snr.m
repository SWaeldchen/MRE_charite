%% function mredge_amp_guided_wave_to_noise(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Calculates wave-to-noise SNR measure, using amplitude guidance
%	to avoid regions of numerical instability
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_amp_wave_snr(info, prefs)

    [STATS_SUB, AMP_SUB, SNR_SUB] = set_dirs(info, prefs);
    if ~exist(SNR_SUB, 'dir')
        mkdir(SNR_SUB)
    end
    NIFTI_EXTENSION = '.nii.gz';
    AMPLITUDE_THRESHOLD = 2;
	amp_vox_filepath = fullfile(STATS_SUB, 'pct_amp_vox.csv');
    w2n_filepath = fullfile(STATS_SUB, 'w2n.csv');
	amp_vox_ID = fopen(amp_vox_filepath, 'w');
    w2n_ID = fopen(w2n_filepath, 'w');
    fprintf(amp_vox_ID, 'F.C, Pct High Amp \n');
	fprintf(w2n_ID, 'F.C, W2N \n');
    for f = info.driving_frequencies
        display([num2str(f), ' Hz']);
        pct_high_amp_vox = zeros(3,1);
        w2n = zeros(3,1);
        for c = 1:3
            display(num2str(c));
            snr_dir = fullfile(SNR_SUB, num2str(f), num2str(c));
            if ~exist(snr_dir, 'dir')
                mkdir(snr_dir);
            end
            snr_path = fullfile(SNR_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
            snr_path = mredge_unzip_if_zip(snr_path);
            snr_vol = load_untouch_nii(snr_path);
			snr_img = snr_vol.img;

			amp_path = fullfile(AMP_SUB, num2str(f), [num2str(f), NIFTI_EXTENSION]);
            amp_vol = load_untouch_nii(amp_path);
			amp_img = double(amp_vol.img);

			mask = double(mredge_load_mask(info,prefs));
			
			snr_filtered = snr_img(amp_img.*mask > AMPLITUDE_THRESHOLD);
			pct_high_amp_vox(c) = numel(snr_filtered) ./ numel(mask(mask == 1));
			w2n(c) = median(snr_filtered);
            amp_vox_ID = fopen(amp_vox_filepath, 'a');
        end
        w2n_ID = fopen(w2n_filepath, 'a');
        fprintf(amp_vox_ID, '%d, %1.3f \n', f, norm(pct_high_amp_vox));
        fprintf(w2n_ID, '%d, %1.3f \n', f, norm(w2n));
        fclose(amp_vox_ID);
        fclose(w2n_ID);
    end
	fclose('all');

end 
    
function [STATS_SUB, AMP_SUB, SNR_SUB] = set_dirs(info, prefs)

    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
	AMP_SUB = mredge_analysis_path(info, prefs, 'Amp');
	if strcmp(prefs.phase_unwrap, 'gradient') == 1
        SNR_SUB = mredge_analysis_path(info, prefs, 'SNR X'); % only one required as they will be comparable
	else
		SNR_SUB = mredge_analysis_path(info, prefs, 'SNR');
	end
    
end

