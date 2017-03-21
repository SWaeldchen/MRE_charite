%% function mredge_organize_acquisition(info, prefs)

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


disp('Organizing Acquisition Folder...');
NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
nifti_convert_command = ['dcm2niix -f %s -z n ',info.path];
evalc('system(nifti_convert_command);');

%% process each series

if ~isempty(info.phase)
	PHASE_SUB = fullfile(info.path,'Phase');
	if ~exist(PHASE_SUB, 'dir')
		mkdir(PHASE_SUB);
    end
    if info.all_freqs_one_series == 1
		mredge_break_into_frequencies(info.phase(1), PHASE_SUB, info);
	else
		disp('Currently disabled for multiple series -- contact developer to enable.');
	    %for n = info.phase
	    %	 mredge_rename_by_frequency(info.phase, PHASE_SUB, info.driving_frequencies);
	    %end
    end
    mredge_phase2double(info);
end

if ~isempty(info.magnitude)
    MAG_SUB = fullfile(info.path,'Magnitude');
	if ~exist(MAG_SUB, 'dir')
		mkdir(MAG_SUB);
	end
	if info.all_freqs_one_series == 1
		mredge_break_into_frequencies(info.magnitude(1), MAG_SUB, info);
	else
		disp('Currently disabled for multiple series -- contact developers to enable.');
    end
    mredge_mag2double(info);
    mredge_average_magnitude(info, prefs);
end

if ~isempty(info.t1)
    T1_SUB = fullfile(info.path, 'T1');
    if ~exist(T1_SUB, 'dir')
		mkdir(T1_SUB);
    end
    for n = info.t1
      movefile(fullfile(info.path, [num2str(n),NIFTI_EXTENSION]), T1_SUB);
    end
end

if ~isempty(info.t2)
    T2_SUB = fullfile(info.path, 'T2');
    if ~exist(T2_SUB, 'dir')
		mkdir(T2_SUB);
    end
    for n = info.t2
       movefile(fullfile(info.path, [num2str(n),NIFTI_EXTENSION]), T2_SUB);
    end
end

if ~isempty(info.localizer)
    LOCALIZER_SUB = fullfile(info.path, 'Localizer');
    if ~exist(LOCALIZER_SUB, 'dir')
		mkdir(LOCALIZER_SUB);
    end
    for n = info.localizer
       movefile(fullfile(info.path, [num2str(n),NIFTI_EXTENSION]), LOCALIZER_SUB);
    end
end

if ~isempty(info.fieldmap)
    FIELDMAP_SUB = fullfile(info.path, 'Fieldmap');
    if ~exist(FIELDMAP_SUB, 'dir')
		mkdir(FIELDMAP_SUB);
    end
    for n = info.fieldmap
       movefile(fullfile(info.path, [num2str(n),NIFTI_EXTENSION]), FIELDMAP_SUB, 'f');
    end
end

if ~isempty(info.dti)
    DTI_SUB = fullfile(info.path, 'DTI');
    if ~exist(DTI_SUB, 'dir')
		mkdir(DTI_SUB);
    end
    for n = info.dti
       movefile(fullfile(info.path, [num2str(n),NIFTI_EXTENSION]), DTI_SUB);
    end
end

if ~isempty(info.other)
    OTHER_SUB = fullfile(info.path, 'Other');
    if ~exist(OTHER_SUB, 'dir')
		mkdir(OTHER_SUB);
    end
    for n = info.other
       movefile(fullfile(info.path, [num2str(n),NIFTI_EXTENSION]), OTHER_SUB);
    end
end

STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
if ~exist(STATS_SUB, 'dir')
    mkdir(STATS_SUB);
end

cd(called_dir)
delete(fullfile(info.path, '*.nii'));

