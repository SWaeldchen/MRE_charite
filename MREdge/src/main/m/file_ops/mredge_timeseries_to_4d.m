function mredge_timeseries_to_4d(subdir, series, component)
% Converts a timeseries of 3D nii files to a 4D nii file
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
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%


NIF_EXT = '*.nii';
time_series_list = dir(fullfile(subdir, num2str(series), num2str(component), NIF_EXT));
num_time_series = numel(time_series_list);
cell_array = cell(num_time_series, 1);
for t = 1:num_time_series
  cell_array{t} = fullfile(subdir, num2str(series), num2str(component), time_series_list(t).name);
end

mredge_3d_to_4d(cell_array, subdir, series, component);

for n = 1:numel(cell_array)
    delete(cell_array{n});
end
