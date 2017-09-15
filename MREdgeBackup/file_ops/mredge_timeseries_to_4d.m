%% function mredge_timeseries_to_4d(cell_array, name_4d)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Converts a timeseries of 3D nii files to a 4D nii file.
%
% INPUTS:
%
% time_series_subdir - subdir containing the time series
% series_num - number of the acquisition series
% n - number of the time series
%
% OUTPUTS:
%
% none

function mredge_timeseries_to_4d(subdir, series, component)

NIFTI_EXTENSION = '*.nii';
time_series_list = dir(fullfile(subdir, num2str(series), num2str(component), NIFTI_EXTENSION));
num_time_series = numel(time_series_list);
cell_array = cell(num_time_series, 1);
for t = 1:num_time_series
  cell_array{t} = fullfile(subdir, num2str(series), num2str(component), time_series_list(t).name);
end

mredge_3d_to_4d(cell_array, subdir, series, component);

for n = 1:numel(cell_array)
    delete(cell_array{n});
end
