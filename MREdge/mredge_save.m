function mredge_save(path)
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Makes directory if necessary, then saves file. Needed for saving to 
%   analysis folders
%
% INPUTS:
%
%   path - save path
%
% OUTPUTS:
%
%   none

folder = fileparts(path);
if ~exist(folder)
    mkdir(folder, 's');
end
