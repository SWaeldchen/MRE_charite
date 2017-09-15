%% function mredge_temporal_ft(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Temporally Fourier-transforms the complex wave field.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_rezip(info, subdir)

	NIFTI_UNZIP_EXTENSION = '.nii';

	
        for f = info.driving_frequencies
            for c = 1:3
                file_path = fullfile(info.path, subdir, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_UNZIP_EXTENSION))
                if exist(file_path, 'file')
					gzip(file_path);
				end
            end
        end    

end


