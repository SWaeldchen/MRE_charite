%% function mredge_clean_acquisition_folder(info)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Restores acquisition folder to its original state
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% none

function mredge_clean_acquisition_folder(info)

dir_names = {'Phase', 'Magnitude', 'T1', 'T2', 'Localizer', 'Fieldmap', 'DTI', 'Other', 'Real', 'Imaginary', 'FT'};
for n = dir_names
	full_dir = fullfile(info.path, cell2str(n));
	if exist(full_dir, 'dir')
		rmdir(full_dir, 's');
	end
end

