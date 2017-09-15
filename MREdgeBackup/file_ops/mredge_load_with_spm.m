%% function mredge_load_with_spm(path)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Loads NIfTI files using SPM functions, to preserve data types etc.
%
%
% INPUTS:
%
% dir - location of the time series
%
% OUTPUTS:
%
% none

function [image, header] = mredge_load_with_spm(path)
    path_gz = [path, '.gz'];
    if exist(path_gz, 'file')
      gunzip(path_gz)
    end
    header = spm_vol(path);
    image = spm_read_vols(header);
end
