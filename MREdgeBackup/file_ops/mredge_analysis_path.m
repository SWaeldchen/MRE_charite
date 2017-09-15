function path = mredge_analysis_path(info, prefs, subdir)
%% function mredge_analysis_path(info, subdir);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   generates uniform analysis folder path names
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   subdir - name of analysis parameter
%
% OUTPUTS:
%
%   none

if numel(prefs.analysis_descriptor) > 0
    prefs.analysis_descriptor = ['_', prefs.analysis_descriptor];
end
if nargin < 3
path = fullfile(info.path, ['AN_', sprintf('%.3d', prefs.analysis_number), sprintf('%s', prefs.analysis_descriptor)]);
else
path = fullfile(info.path, ['AN_', sprintf('%.3d', prefs.analysis_number), sprintf('%s', prefs.analysis_descriptor)], subdir);
end  
