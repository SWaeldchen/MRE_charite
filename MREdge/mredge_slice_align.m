%% function mredge_phase_unwrap(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls gaussian smoothing on real and imaginary MRE acquisition data
%	(prior to phase unwrapping)
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_slice_align(info, prefs)

FT_SUB = set_dirs(info, prefs);
NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');

for f = info.driving_frequencies
    for c = 1:3
        vol_dir = fullfile(FT_SUB, num2str(f), num2str(c));
        vol_path = fullfile(vol_dir, mredge_filename(f, c, NIFTI_EXTENSION));
        vol = load_untouch_nii_eb(vol_path);
        vol.img = dejitter_phase_2(vol.img, 1, 256);
        save_untouch_nii(vol, vol_path);
    end
end

end

function FT_SUB = set_dirs(info, prefs)
    FT_SUB = mredge_analysis_path(info, prefs, 'FT');
end
