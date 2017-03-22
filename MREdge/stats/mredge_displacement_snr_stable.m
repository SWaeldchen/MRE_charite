%% function mredge_laplacian_snr_stable(info, prefs)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Calculates the Laplacian SNR for the stable inversions of the image set.
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
% prefs - mredge preferences file
%
% OUTPUTS:
%
% none

%%
function mredge_displacement_snr_stable(info, prefs)

	disp('Displacement SNR');
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    [AMP_SUB, STATS_SUB] = set_dirs(info, prefs);
    mask = mredge_load_mask(info, prefs);
    % ALL case
    filepath = fullfile(STATS_SUB, 'displacement_snr_single.csv');
    fID = fopen(filepath, 'w');		
    amp_file = fullfile(AMP_SUB, ['ALL', NIFTI_EXTENSION]);
    amp_vol = load_untouch_nii_eb(amp_file);
    displacement_noise(amp_vol.img, filepath, mask);
    filepath = fullfile(STATS_SUB, 'displacement_snr_stable.csv');
    fID = fopen(filepath, 'w');
    fprintf(fID, 'Displacement_Noise_Stable\n');
 	[stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, 0);
	for f = 1:numel(stable_frequencies)
		%disp([num2str(stable_frequencies(f)), 'Hz']);
		amp_file = fullfile(AMP_SUB, stable_filenames{f});
        amp_vol = load_untouch_nii_eb(amp_file);
		displacement_noise(amp_vol.img, filepath, mask);
	end
    
end

function [AMP_SUB, STATS_SUB] = set_dirs(info, prefs)

    AMP_SUB = mredge_analysis_path(info, prefs, 'Amp');
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');

end

function displacement_noise(amp, filepath, mask)
    SNR_pct = signal_power(amp, mask) ./ mad_est_3d(amp, mask);
    SNR_db = 10 * log(SNR_pct) ./ log(10);
    fID = fopen(filepath, 'a');
    fprintf(fID, '%1.3f\n', SNR_db);
    fclose('all');
end
