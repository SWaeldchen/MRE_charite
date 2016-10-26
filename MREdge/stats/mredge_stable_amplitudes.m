%% function mredge_stable_amplitudes(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Creates sliding window amplitudes, expected use is the weighted stable
%	springpot.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function [stable_filenames, stable_frequencies] = mredge_stable_amplitudes(info, prefs)
    if nargin < 2
        invert = 0;
    end
	AMP_SUB = set_dirs(info, prefs);
    df = info.driving_frequencies;
    nf = numel(df);
    stable_filenames = cell(nf-2, 1);
    stable_frequencies = zeros(nf-2, 1);
    [freqs_sorted, freq_indices] = sort(info.driving_frequencies, 'ascend');
    for n = 1:nf-2
        stable_group = [freqs_sorted(n), freqs_sorted(n+1), freqs_sorted(n+2)];
        stable_group_indices = [freq_indices(n), freq_indices(n+1), freq_indices(n+2)];
		create_stable_amplitude(stable_group, stable_group_indices, AMP_SUB);
        stable_filenames{n} = [num2str(stable_group(1)),'_',num2str(stable_group(2)),'_',num2str(stable_group(3)), '.nii.gz'];
        stable_frequencies(n) = mean(stable_group);
    end
end

function AMP_SUB = set_dirs(info, prefs)
	AMP_SUB = mredge_analysis_path(info, prefs, 'Amp');
end

function create_stable_amplitude(stable_group, stable_group_indices, AMP_SUB)
	first_amp_path = fullfile(AMP_SUB, num2str(stable_group(1)), [num2str(stable_group(1)), '.nii.gz']);
	amp_sum_vol = load_untouch_nii(first_amp_path);
	for n = 2:numel(stable_group)
		amp_path = fullfile(AMP_SUB, num2str(stable_group(n)), [num2str(stable_group(n)), '.nii.gz']);
		amp_path = mredge_unzip_if_zip(amp_path);
		amp_vol = load_untouch_nii(amp_path);
		amp_sum_vol.img = amp_sum_vol.img + amp_vol.img;
	end
	stable_filename = [num2str(stable_group(1)),'_',num2str(stable_group(2)),'_',num2str(stable_group(3)), '.nii.gz'];
	save_untouch_nii(amp_sum_vol, fullfile(AMP_SUB, stable_filename));
end
	
	
