function [dir_list, dir_constants] = mredge_dir_list(info)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% info - mredge info object
% 
% INPUTS:
%
% none
%
% OUTPUTS:
%
% dir_list: master directory list.
% dir_constants: struct of constants that can index the dir_list

dir_list = {'magnitude', 'phase', 't1', 't2', 'localizer', 'fieldmap', 'dti', 'other'};

for n = 1:numel(dir_list)
    dir_list{n} = fullfile(info.path, dir_list{n});
end

dir_constants.phase = 1;
dir_constants.magnitude = 2;
dir_constants.t1 = 3;
dir_constants.t2 = 4;
dir_constants.localizer = 5;
dir_constants.fieldmap = 6;
dir_constants.dti = 7;
dir_constants.other = 8;