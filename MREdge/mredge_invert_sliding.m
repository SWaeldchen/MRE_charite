%% function mredge_invert_sliding(info, prefs,invert);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%

function [stable_filenames, stable_frequencies] = mredge_invert_sliding(info, prefs, invert)
    NIF_EXT = getenv('NIFTI_EXTENSION');
    if nargin < 2
        invert = 0;
    end
    df = info.driving_frequencies;
    nf = numel(df);
    stable_filenames = cell(nf-2, 1);
    stable_frequencies = zeros(nf-2, 1);
    [freqs_sorted, freq_indices] = sort(info.driving_frequencies, 'ascend');
    for n = 1:nf-2
        stable_group = [freqs_sorted(n), freqs_sorted(n+1), freqs_sorted(n+2)];
        stable_group_indices = [freq_indices(n), freq_indices(n+1), freq_indices(n+2)];
        if invert == 1
			if strcmpi(prefs.inversion_strategy,'MDEV') == 1
            	mredge_invert_param_mdev(info, prefs, 'Abs_G', stable_group_indices);
			elseif strcmpi(prefs.inversion_strategy,'SFWI') == 1
				mredge_invert_sfwi(info, prefs, stable_group_indices);
			end
        end
        stable_filenames{n} = [num2str(stable_group(1)),'_',num2str(stable_group(2)),'_',num2str(stable_group(3)), NIF_EXT];
        stable_frequencies(n) = mean(stable_group);
    end
end

