%% function data_table = mredge_dicom_data_table(info)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Creates table containing DICOM filenames, series numbers, and instance
% numbers, to facilitate merging into 4D NIfTI structures
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% data_table - a table with filenames, series numbers, and instance numbers

%% collect series numbers

function [data_table] = mredge_dicom_data_table(info)

% assume we are in the directory by mredge_acquisition_info

% make DICOM data table
display('Creating DICOM data table...');
file_names = dir(fullfile(info.path,['*',info.file_extension]));
total_files = numel(file_names);
series_numbers = [];
instance_numbers = [];
dicom_file_names = [];
inc = 0;
for k=1:total_files
    inc = inc+1;
    if mod(inc, round(total_files/10)) == 0
      display([num2str(round(inc / total_files * 100)), '% complete...'])
    end
    file_name = file_names(k).name;
    if isdicom(file_name)
        slice_dicom_info = dicominfo(deblank(file_names(k).name));
        series_number = slice_dicom_info.SeriesNumber;
        series_numbers = cat(1, series_numbers, series_number);
        instance_number = slice_dicom_info.InstanceNumber;
        instance_numbers = cat(1, instance_numbers, instance_number);
        dicom_file_names = char(dicom_file_names, fullfile(info.path, file_name));
    end
end
dicom_file_names = dicom_file_names(2:end,:);
data_table = {series_numbers, instance_numbers, dicom_file_names};
