%% function mredge_stable_inversions(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Helmholt-Hodge decomposition of the vector fields, retaining curl
%   component
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%	invert - flag for inverting the data. 1 creates the special inversion and
%		0 only returns the stable filenames and frequencies
%
% OUTPUTS:
%
%   none

function [stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, invert)
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
            mredge_invert_param_mdev(info, prefs, 'Abs_G', stable_group, stable_group_indices);
            mredge_invert_param_mdev(info, prefs, 'Phi', stable_group, stable_group_indices);
        end
        stable_filenames{n} = [num2str(stable_group(1)),'_',num2str(stable_group(2)),'_',num2str(stable_group(3)), '.nii.gz'];
        stable_frequencies(n) = mean(stable_group);
    end
end

