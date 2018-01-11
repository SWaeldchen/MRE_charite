function dir_path = mredge_mkdir(dir_path)
% Checks if directory exists, then makes it
%
% INPUTS:
%
% dir_path - directory path
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
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
