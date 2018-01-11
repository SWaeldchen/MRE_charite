function mredge_set_environment
% Set environment variables for MREdge
%
% INPUTS:
%
% none
%
% OUTPUTS:
%
% none
%
% NOTE:
%
% If you use MREdge frequently, this script can be called automatically
% by adding the line mredge_set_enironment to your startup.m file .
%
% (If you don't know where that is, type 'which startup.m'.)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.

setenv('MREDGE_ENV_SET', '1');
MREDGE_DIR = cell2str(importdata('mredge_dir.txt'));
setenv('MREDGE_DIR', MREDGE_DIR)
addpath(genpath(MREDGE_DIR));
setenv('TOPUP_PARAMS', '/home/ericbarnhill/Documents/MATLAB/ericbarnhill/m-code/fehlner/pipeline/topup_param.txt');
setenv('NIFTI_EXTENSION', '.nii');
setenv('RHO', '1000');
setenv('ABSG_NOISE_THRESH', '300');
setenv('SFWI_NOISE_THRESH', '500');
nifti_convert_command = ['dcm2niix -f %s -z n '];
setenv('NIFTI_CONVERT_COMMAND', nifti_convert_command);
setenv('PHASE_DIVISOR', '4096');
javaaddpath(fullfile(MREDGE_DIR, 'src', 'main', 'jar', 'jvcl-0.1.jar'));
javaaddpath(fullfile(MREDGE_DIR, 'src', 'main', 'jar', 'Magnitude-0.1.jar'));

