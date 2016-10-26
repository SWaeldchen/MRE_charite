%% function mredge_sort_by_time_series(series_subdir, time_steps)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Organizes DICOM slices into nifti files, guided by acquisition info object, and
% divides into folders by time series.
%
% INPUTS:
%
% series_subdir - subdir of DICOM series
% time_steps - time steps in the acquisition. required for 4D conversion
%
% OUTPUTS:
%
% none

%% collect series numbers

function mredge_sort_by_time_series(subdir, series, info)
  series_list = dir(fullfile(subdir, num2str(series), '*.nii'));
  num_time_series = numel(series_list) / info.time_steps;
  for c = 1:num_time_series
      time_series_subdir = fullfile(subdir, num2str(series), num2str(c));
      if ~exist(time_series_subdir, 'dir')
          mkdir(time_series_subdir);
      end
      start_index = (c-1)*info.time_steps + 1;
      end_index = c*info.time_steps;
      for p = start_index:end_index
          movefile(fullfile(subdir, num2str(series), series_list(p).name), fullfile(subdir, num2str(series), num2str(c), series_list(p).name));
      end
      mredge_timeseries_to_4d(subdir, series, c);
  end
    

