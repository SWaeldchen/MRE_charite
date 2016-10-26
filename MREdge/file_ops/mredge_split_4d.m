%% function file_list = mredge_split_4d(subdir, series, component)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Uses FSL split to split a 4D .nii.gz file into a file list. Default
% format is 'vol0000.nii.gz', 'vol0001.nii.gz', etc.%
%
% INPUTS:
%
% subdir - acquisition subdirectory (e.g. 'Phase')
% series - driving frequency
% component - component of motion
%
% OUTPUTS:
%
% file_list - cell of paths to split files

function file_list = mredge_split_4d(subdir, series, component, info)
	FSL_SPLIT_PREFIX = 'vol000';
    name_4d = mredge_filename(series, component, '.nii.gz');
    path_4d = fullfile(subdir, num2str(series), num2str(component), name_4d);
    comp_dir = fullfile(subdir,num2str(series), num2str(component));
    system(['fsl5.0-fslsplit ',path_4d,' ', comp_dir,'/vol']);
    file_list = cell(info.time_steps, 1);
    for t = 1:info.time_steps
      file_list{t} = [comp_dir, '/', FSL_SPLIT_PREFIX, num2str(t-1), '.nii.gz'];
    end
end
