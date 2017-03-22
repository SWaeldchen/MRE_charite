%% function mredge_filepath(DIR, f, c)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Creates a file path given directory, frequency and component
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

function path = mredge_filepath(DIR, f, c)
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    path = fullfile(DIR, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
end
