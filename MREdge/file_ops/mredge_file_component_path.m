function path = mredge_file_component_path(subdir, comp)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Provides file path given frequency and component number
%
% INPUTS:
%
%   subdir - subdirectory structure from mredge_dir_struct
%   comp - directional component (integer from 1 to 3)
%
% OUTPUTS:
%
%   none
   
path = fullfile(num2str(cell2mat(subdir)), num2str(comp), [num2str(cell2mat(subdir)), '_', num2str(comp), getenv('NIFTI_EXTENSION')]);



