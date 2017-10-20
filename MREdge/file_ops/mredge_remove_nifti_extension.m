function path_trunc = mredge_remove_nifti_extension(path)
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% Strips file extension from a nifti file, to allow alteration of
% filenames.
%
% INPUTS:
%
% path - a nifti file path, probably from info.ds.subdirs_comps_files
%
% OUTPUTS:
%
% truncated pathname
%	

NIF_EXT = getenv('NIFTI_EXTENSION');
trunc_num = numel(NIF_EXT);
path_trunc = path(1:end-trunc_num);