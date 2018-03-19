function path = mredge_analysis_path(info, prefs, subdir)
% Generates uniform analysis folder path names
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   subdir - name of analysis parameter
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_create_analysis_folder
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
if numel(prefs.analysis_descriptor) > 0
    %prefs.analysis_descriptor = ['_', prefs.analysis_descriptor];
end
if nargin < 3
    path = fullfile(info.path, mredge_analysis_folder_name(prefs));
else
    path = fullfile(info.path, mredge_analysis_folder_name(prefs), subdir);
end  
