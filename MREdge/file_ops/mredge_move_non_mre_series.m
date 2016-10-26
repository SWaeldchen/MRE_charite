%% function mredge_move_non_mre_series(series_num, data_table, dir)
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

function mredge_move_non_mre_series(series_num, data_table, subdir)

display(['Organizing series ', num2str(series_num)])
series_dicom_dir = fullfile(subdir, 'DICOM/');
if ~exist(series_dicom_dir, 'dir')
    mkdir(series_dicom_dir)
end
series_numbers = data_table{1};
file_names = data_table{3};
current_series = find(series_numbers == series_num);
num_current_series = numel(current_series);
files_cat = file_names(current_series(1),:);
for n = 2:num_current_series
    files_cat = char(files_cat, file_names(current_series(n),:));
end
assignin('base', ['files_cat_',num2str(series_num)], files_cat);
hdr_table = spm_dicom_headers(files_cat);
for n = 1:numel(hdr_table)
    movefile(hdr_table{n}.Filename, series_dicom_dir);
end



