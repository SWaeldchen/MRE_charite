function mredge_set_environment
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Sets environment variables.
% If you use MREdge frequently, this script can be called automatically
% by adding the line mredge_set_enironment to your startup.m file .
%
% (If you don't know where that is, type 'which startup.m'.)
%
% It 
%
% INPUTS:
%
% dir - location of the time series
%
% OUTPUTS:
%
% none

setenv('TOPUP_PARAMS', fullfile(getenv('MRE'), 'projects/project_modico/pipeline/topup_param.txt'));
setenv('NIFTI_EXTENSION', '.nii');
setenv('RHO', '1000');
setenv('ABSG_NOISE_THRESH', '300');
setenv('SFWI_NOISE_THRESH', '500');
nifti_convert_command = ['C:\Program Files\mricron\dcm2nii.exe -f %s -z n '];
setenv('NIFTI_CONVERT_COMMAND', nifti_convert_command);
setenv('PHASE_DIVISOR', '4096');
