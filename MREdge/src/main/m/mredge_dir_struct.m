function dir_struct = mredge_dir_struct(info)
% Creates dir_struct object, which enables clean looping in mredge methods.
%
% INPUTS:
%
%   info: mredge info object
%
% OUTPUTS:
%
%   dir_struct: a struct containing the above items
%
% NOTE:
%
%   This method sets up all the directory structures needed for 
%   MREdge processing. This allows looping through various types
%   of files in MREdge code to be clean, consistent and convenient.
%
%   The struct has the following components:
%
%   list:  a list of all possible non-analysis folders
%
%   enum: an enum of indices for the dir list
%
%   series_nums: the series numbers for each of the dirs used in the project
%
%   logical: a logical of which directories are used in the project
%
%   subdirs: a cell array of frequency directory names. note that subdirs
%       include the nifti file name since it is always the same.
%
%   subdirs_files: a cell array of frequency directory file names
%
%   subdirs_comps: a cell array of frequency and component directory names
%
%   subdirs_comps_files: a cell array of frequency and component directory file names
%
% SEE ALSO:
%
%   mredge_info
% 
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%

NIF_EXT = getenv('NIFTI_EXTENSION');

% ACQ LIST
list = {'phase', 'magnitude', 't1', 't2', 'localizer', 'fieldmap', ...
    'dti', 'other', 'real', 'imaginary'};

for n = 1:numel(list)
    list{n} = fullfile(info.path, list{n});
end

% ENUM
dir_enum.phase = 1;
dir_enum.magnitude = 2;
dir_enum.t1 = 3;
dir_enum.t2 = 4;
dir_enum.localizer = 5;
dir_enum.fieldmap = 6;
dir_enum.dti = 7;
dir_enum.other = 8;
dir_enum.real = 9;
dir_enum.imaginary = 10;

% SERIES NUMS
series_nums = {info.phase, info.magnitude, info.t1, info.t2, ...
    info.localizer, info.fieldmap, info.dti, info.other};

% LOGICAL
dir_logical = false(8,1);
for d = 1:numel(series_nums)
    if isempty(series_nums{d})
        dir_logical(d) = false;
    else
        dir_logical(d) = true;
    end
end

nfreqs = numel(info.driving_frequencies);
ncomps = 3;
subdirs = cell(nfreqs,1);
subdirs_files = cell(nfreqs,1);
subdirs_comps = cell(nfreqs*3,1);
subdirs_comps_files = cell(nfreqs*3,1);
for n = 1:nfreqs
    df = info.driving_frequencies(n);
    subdirs{n} = df;
    subdirs_files{n} = [num2str(df), '/', num2str(df), NIF_EXT];
    for m = 1:ncomps
        index = (n-1)*ncomps + m;
        subdirs_comps{index} = [num2str(df), '/', num2str(m), '/'];
        subdirs_comps_files{index} = [num2str(df), '/', num2str(m), '/', num2str(df), '_', num2str(m), NIF_EXT];
    end
end

dir_struct.list = list;
dir_struct.enum = dir_enum;
dir_struct.series_nums = series_nums;
dir_struct.logical = dir_logical;
dir_struct.subdirs = subdirs';
dir_struct.subdirs_files = subdirs_files';
dir_struct.subdirs_comps = subdirs_comps';
dir_struct.subdirs_comps_files = subdirs_comps_files';
    


