%% function mredge_3d_to_4d_moco(cell_array, name_4d)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Call to spm to convert 3D to 4D nii file. 
%
% INPUTS:
%
% cell_array - cell array of 3d nii file names
% path - can be preset filename, or subdir
% series - if subdir, this is the driving series
% component - if subdir, this is the motion component
%
% OUTPUTS:
%
% none

function mredge_3d_to_4d_moco(cell_array, subdir, series, component)
  
  method = 'fsl';
  NIFTI_EXTENSION = '.nii.gz';

  if nargin == 4
     name_4d = fullfile(subdir, num2str(series), num2str(component), mredge_filename(series, component, NIFTI_EXTENSION, 'MOCO_MASK'));
  else
     name_4d = [subdir, '_MOCO_MASK'];
  end
  
  if strcmp(method, 'spm') == 1
    job{1}.spm.util.cat.vols = cell_array;
    job{1}.spm.util.cat.name = name_4d;
    job{1}.spm.util.cat.dtype = 4;
    spm_jobman('initcfg');
    spm_jobman('run',job);
    gzip(name_4d);
    delete(name_4d);
  end

  if strcmp(method, 'fsl') == 1
    file_list = ' ';
    for n = 1:numel(cell_array)
      file_list = [file_list, cell_array{n}, ' ']; %#ok<AGROW>
    end
	merge_command = ['fsl5.0-fslmerge -t ', name_4d, file_list];
    system(merge_command);
 end
