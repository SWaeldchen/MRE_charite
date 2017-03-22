%% function mredge_filepath(DIR, f, c)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Makes a subdirectory for the frequency and component
%
% INPUTS:
%
% DIR - directory path
% f - frequency in Hz
% c - directional component (1, 2, or 3)
%
% OUTPUTS:
%
% text string containing the full path

function dir_path = mredge_mkdir(DIR, f, c)
    dir_path = mredge_dirpath(DIR, f, c);
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
    end
end
