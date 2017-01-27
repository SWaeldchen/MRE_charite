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

%% collect series numbers

function mredge_clean_acquisition_folder(info, delete_data_table)

cd(info.path)
if nargin > 1 && delete_data_table == 1
    delete('data_table.mat');
end

%% process each series
% phase is required, so we don't need to check for empty field

PHASE_SUB = fullfile(info.path,'Phase');
if exist(PHASE_SUB, 'dir')
    movefile(fullfile(PHASE_SUB, 'DICOM/*'), info.path);
    rmdir(PHASE_SUB,'s');
end

if ~isempty(info.magnitude)
    MAG_SUB = fullfile(info.path,'Magnitude');
    if exist(MAG_SUB, 'dir')
        movefile(fullfile(MAG_SUB, 'DICOM/*'), info.path);
        rmdir(MAG_SUB,'s');
    end
end

if ~isempty(info.t1)
    T1_SUB = fullfile(info.path,'T1');
    if exist(T1_SUB, 'dir')
        movefile(fullfile(T1_SUB, 'DICOM/*'), info.path);
        rmdir(T1_SUB,'s');
    end
end

if ~isempty(info.t2)
    T2_SUB = fullfile(info.path,'T2');
    if exist(T2_SUB, 'dir')
        movefile(fullfile(T2_SUB, 'DICOM/*'), info.path);
        rmdir(T2_SUB,'s');
    end
end

if ~isempty(info.localizer)
    LOCALIZER_SUB = fullfile(info.path, 'Localizer');
    if exist(LOCALIZER_SUB, 'dir')
        movefile(fullfile(LOCALIZER_SUB, 'DICOM/*'), info.path);
        rmdir(LOCALIZER_SUB,'s');
    end
end

if ~isempty(info.fieldmap)
    FIELDMAP_SUB = fullfile(info.path, 'Fieldmap');
    if exist(FIELDMAP_SUB, 'dir')
        movefile(fullfile(FIELDMAP_SUB, 'DICOM/*'), info.path);
        rmdir(FIELDMAP_SUB,'s');
    end
end

if ~isempty(info.dti)
    DTI_SUB = fullfile(info.path, 'DTI');
    if exist(DTI_SUB, 'dir')
        movefile(fullfile(DTI_SUB, 'DICOM/*'), info.path);
        rmdir(DTI_SUB,'s');
    end
end

if ~isempty(info.other)
    OTHER_SUB = fullfile(info.path, 'OTHER');
    if exist(OTHER_SUB, 'dir')
        movefile(fullfile(OTHER_SUB, 'DICOM/*'), info.path);
        rmdir(OTHER_SUB,'s');
    end
end

% remove temporary working directories, if they exist
REAL_SUB = fullfile(info.path,'Real');
IMAG_SUB = fullfile(info.path,'Imaginary');
FT_SUB = fullfile(info.path,'FT');

working_dir_list = {REAL_SUB, IMAG_SUB, FT_SUB};

for n = 1:numel(working_dir_list)
    working_dir = working_dir_list{n};
    if exist(working_dir, 'dir')
        rmdir(working_dir,'s')
    end
end

