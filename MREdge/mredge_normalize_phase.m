%% function mredge_normalize_phase(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Normalizes the phase of the data to [0, 2pi) .
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_normalize_phase(info, prefs)

	[PHASE_SUB] =set_dirs(info, prefs);
	NIFTI_EXTENSION = '.nii.gz';

        for f = info.driving_frequencies
            for c = 1:3
                time_series_path = fullfile(PHASE_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
				path_list = mredge_split_4d(PHASE_SUB, f, c, info);
                for n = 1:numel(path_list)
                    path = path_list{n};
                    phase_vol = load_untouch_nii(path);
					if ~isempty(prefs.phase_unwrapping_settings.phase_range)
						range_array = prefs.phase_unwrapping_settings.phase_range;
						range = range_array(2) - range_array(1);
						phase_vol.img = ( (phase_vol.img - range_array(1)) / range ) * 2 * pi;
					else
						phase_vol.img = normalizeImage(phase_vol.img)*2*pi;
					end
					save_untouch_nii(phase_vol, path);
                end
                mredge_3d_to_4d(path_list, PHASE_SUB, f, c);
            end
        end

    

end

function [PHASE_SUB] = set_dirs(info, prefs)
	PHASE_SUB = fullfile(info.path, 'Phase');
end


