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
function mredge_laplacian_snr_stable(info, prefs)

	disp('Laplacian SNR');
    NIF_EXT = getenv('NIFTI_EXTENSION');
    [AMP_SUB, STATS_SUB] = set_dirs(info, prefs);
    mask = mredge_load_mask(info, prefs);
    % ALL case
    filepath = fullfile(STATS_SUB, 'laplacian_snr_single.csv');
    fID = fopen(filepath, 'w');		
    amp_file = fullfile(AMP_SUB, ['ALL', NIF_EXT]);
    amp_vol = load_untouch_nii_eb(amp_file);
    laplacian_noise(amp_vol.img, filepath, mask);
    if prefs.sliding_windows
        filepath = fullfile(STATS_SUB, 'laplacian_snr_stable.csv');
        fID = fopen(filepath, 'w');
        fprintf(fID, 'Laplacian_Noise_Stable\n');
        [stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, 0);
        for f = 1:numel(stable_frequencies)
            amp_file = fullfile(AMP_SUB, stable_filenames{f});
            amp_vol = load_untouch_nii_eb(amp_file);
            laplacian_noise(amp_vol.img, filepath, mask);
        end
    end
end

function [AMP_SUB, STATS_SUB] = set_dirs(info, prefs)

    AMP_SUB = mredge_analysis_path(info, prefs, 'Amp');
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');

end

function laplacian_noise(amp, filepath, mask)
    amp_lap = mredge_compact_laplacian(amp, [1 1 1], 3);
    SNR_pct = signal_power(amp_lap, mask) ./ mad_est_3d(amp_lap, mask);
    SNR_db = 10 * log(SNR_pct) ./ log(10);
    fID = fopen(filepath, 'a');
    fprintf(fID, '%1.3f\n', SNR_db);
    fclose('all');
end
