%% function mredge_organize_acquisition(info)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Organizes DICOM slices into folders, and for MRE acquisitions, 4D nifti files,
% guided by acquisition info object.
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% none

%% collect series numbers

function mredge_organize_acquisition(info, prefs)

called_dir = pwd;

tic
display('Organizing Acquisition Folder...');
cd(info.path)

% make DICOM data table
file_names = dir(['*', info.file_extension]);

if prefs.temporal_ft == 1
	is_time_series = 1;
else
	is_time_series = 0;
end

if ~exist(fullfile(info.path, 'data_table.mat'), 'file')
    data_table = mredge_dicom_data_table(info);
    save(fullfile(info.path, 'data_table.mat'), 'data_table');
end

load('data_table.mat', 'data_table');
assignin('base', 'data_table', data_table);


%% process each series

if ~isempty(info.phase)
	PHASE_SUB = fullfile(info.path,'Phase');
	if ~exist(PHASE_SUB, 'dir')
		mkdir(PHASE_SUB);
	end
	for n = info.phase
	   mredge_dicom_to_nii(n, data_table, PHASE_SUB, is_time_series, info);
	end
	if info.all_freqs_one_series == 1
	   mredge_reorganize_by_frequency(info.phase(1), PHASE_SUB, info.driving_frequencies);
	else
	   mredge_rename_by_frequency(info.phase, PHASE_SUB, info.driving_frequencies);
	end
end

if ~isempty(info.magnitude)
    MAG_SUB = fullfile(info.path, 'Magnitude');
    if ~exist(MAG_SUB, 'dir')
	mkdir(MAG_SUB);
    end
    for n = info.magnitude
      mredge_dicom_to_nii(n, data_table, MAG_SUB, is_time_series, info);
    end
    if info.all_freqs_one_series == 1
        mredge_reorganize_by_frequency(info.magnitude(1), MAG_SUB, info.driving_frequencies);
    else
        mredge_rename_by_frequency(info.magnitude, MAG_SUB, info.driving_frequencies);
    end
    mredge_average_magnitude(info, prefs);
end

if ~isempty(info.t1)
    T1_SUB = fullfile(info.path, 'T1');
    if ~exist(T1_SUB, 'dir')
	mkdir(T1_SUB);
    end
    for n = info.t1
      cd(info.path)
      mredge_dicom_to_nii(n, data_table, T1_SUB, 0, info);
    end
end

if ~isempty(info.t2)
    T2_SUB = fullfile(info.path, 'T2', 'Localizer', 'DICOM');
    if ~exist(T2_SUB, 'dir')
	mkdir(T2_SUB);
    end
    for n = info.t2
      cd(info.path)
      mredge_move_non_mre_series(n, data_table, T2_SUB);
    end
end

if ~isempty(info.localizer)
    LOCALIZER_SUB = fullfile(info.path, 'Localizer', 'DICOM');
    if ~exist(LOCALIZER_SUB, 'dir')
	mkdir(LOCALIZER_SUB);
    end
    for n = info.localizer
      mredge_move_non_mre_series(n, data_table, LOCALIZER_SUB);
    end
end

if ~isempty(info.fieldmap)
    FIELDMAP_SUB = fullfile(info.path, 'Fieldmap');
    if ~exist(FIELDMAP_SUB, 'dir')
	mkdir(FIELDMAP_SUB);
    end
    for n = info.fieldmap
      mredge_dicom_to_nii(n, data_table, FIELDMAP_SUB);
    end
end

if ~isempty(info.dti)
    DTI_SUB = fullfile(info.path, 'DTI', 'DICOM');
    if ~exist(DTI_SUB, 'dir')
	mkdir(DTI_SUB);
    end
    for n = info.dti
      mredge_move_non_mre_series(n, data_table, DTI_SUB);
    end
end

if ~isempty(info.other)
    OTHER_SUB = fullfile(info.path, 'Other', 'DICOM');
    if ~exist(OTHER_SUB, 'dir')
	mkdir(OTHER_SUB);
    end
    for n = info.other
      mredge_move_non_mre_series(n, data_table, OTHER_SUB);
    end
end

STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
if ~exist(STATS_SUB, 'dir')
    mkdir(STATS_SUB);
end

cd(called_dir)

toc
