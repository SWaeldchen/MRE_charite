%% function mredge_move_non_mre_series(series_num, subdir, info)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% For non-MRE acquisitions, moves the DICOM files to a series folder,
% where they can be processed as needed
%
% INPUTS:
%
% info - An acquisition info structure created by make_acquisition_info.
%
% OUTPUTS:
%
% none

%% collect series numbers

function mredge_move_non_mre_series(series_num, subdir, info)
NIF_EXT = getenv('NIFTI_EXTENSION');
display(['Moving non-mre series ', num2str(series_num)])
if ~exist(subdir)
	mkdir(subdir, 'dir');
end
file_list = dir(info.path);
for n = 1:numel(file_list)
	if ~isempty(regexp(file_list(n).name, regexptranslate('wildcard', [num2str(series_num),'*',NIF_EXT])))
		movefile(file_list(n).name, subdir);
	end
end


