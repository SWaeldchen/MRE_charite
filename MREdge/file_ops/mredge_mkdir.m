%% function mredge_mkdir(dir_path)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Checks if directory exists, then makes it
%
% INPUTS:
%
% dir_path - directory path
% 
% OUTPUTS:
%
% none

function dir_path = mredge_mkdir(dir_path)
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
    end
end
