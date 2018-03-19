function path_trunc = mredge_remove_nifti_extension(path)
% Strips file extension from a nifti file, to allow alteration of filenames
%
% INPUTS:
%
% path - a nifti file path, probably from prefs.ds.subdirs_comps_files
%
% OUTPUTS:
%
% truncated pathname
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
NIF_EXT = getenv('NIFTI_EXTENSION');
trunc_num = numel(NIF_EXT);
path_trunc = path(1:end-trunc_num);