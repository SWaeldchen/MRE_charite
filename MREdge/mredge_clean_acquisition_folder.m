function mredge_clean_acquisition_folder(info)
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

% phase is required, so we don't need to check for empty field

for dir = info.ds.list
    path = cell2str(fullfile(info.path, dir));
    if exist(path, 'dir')
        rmdir(path, 's');
    end
end

% remove temporary working directories, if they exist
REAL_SUB = fullfile(info.path,'real');
IMAG_SUB = fullfile(info.path,'imaginary');
FT_SUB = fullfile(info.path,'ft');

working_dir_list = {REAL_SUB, IMAG_SUB, FT_SUB};

for n = 1:numel(working_dir_list)
    working_dir = working_dir_list{n};
    if exist(working_dir, 'dir')
        rmdir(working_dir,'s')
    end
end

