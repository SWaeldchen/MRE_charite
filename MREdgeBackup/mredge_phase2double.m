%% function mredge_phase2double(info);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Make all phase niftis double format, to avoid format conflicts.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_phase2double(info)

	[PHASE_SUB] =set_dirs(info);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');

    for f = info.driving_frequencies
        for c = 1:3
            phase_path = fullfile(PHASE_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
            phase_vol = load_untouch_nii_eb(phase_path);
            phase_vol.img = double(phase_vol.img);
            phase_vol.hdr.dime.datatype = 64;
            save_untouch_nii(phase_vol, phase_path);
        end
    end


end

function [PHASE_SUB] = set_dirs(info)
    PHASE_SUB = fullfile(info.path, 'Phase');
end


