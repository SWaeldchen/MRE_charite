%% function mredge_mag2double(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Make all magnitude niftis double, to avoid format conflicts.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_mag2double(info)

	[MAG_SUB] =set_dirs(info);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');

    for f = info.driving_frequencies
        for c = 1:3
            mag_path = fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
            mag_vol = load_untouch_nii_eb(mag_path);
            mag_vol.img = double(mag_vol.img);
            mag_vol.hdr.dime.datatype = 64;
            save_untouch_nii(mag_vol, mag_path);
        end
    end


end

function [MAG_SUB] = set_dirs(info)
    MAG_SUB = fullfile(info.path, 'Magnitude');
end


