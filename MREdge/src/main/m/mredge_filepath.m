function path = mredge_filepath(DIR, f, c)
% Creates consistent file path given directory, frequency and component
%
% INPUTS:
%
%   DIR - directory path
%   f - frequency in Hz
%   c - directional component (1, 2, or 3)
%
% OUTPUTS:
%
%   text string containing the full path
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
NIF_EXT = getenv('NIFTI_EXTENSION');
path = fullfile(DIR, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));