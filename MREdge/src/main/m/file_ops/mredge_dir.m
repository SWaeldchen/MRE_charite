function file_list = mredge_dir(directory)
% Returns portions of MATLAB's dir command that contain files
%
% INPUTS:
%
%   directory - string of directory
%
% OUTPUTS:
%
%   none
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
file_list_full = dir(directory);
file_list = file_list_full(3:end);