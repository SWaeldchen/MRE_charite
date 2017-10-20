function mredge_create_analysis_folder(info, prefs)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   If analysis folder does not exist, create it.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

if ~exist(mredge_analysis_path(info, prefs), 'dir')
    mkdir(mredge_analysis_path(info, prefs));
    mkdir(fullfile(mredge_analysis_path(info, prefs), 'stats'));
end